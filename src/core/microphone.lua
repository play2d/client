Core.Microphone = {}

local Path = ...
local Microphone = Core.Microphone
local mic = require("src.love-microphone")

function Microphone.Load()
	Microphone.Device = mic.openDevice(nil, nil, 0.1)
	Microphone.Source = mic.newQueueableSource()
	Microphone.Device:setDataCallback(Microphone.RecordData)
	Microphone.Device:start()
	
	Microphone.Server = enet.host_create("localhost:0", 256, 0, 1)
end

function Microphone.Update()
	-- This is only called when holding the record key
	Microphone.Device:poll()
	
	Microphone.Server:service()
	Microphone.Server:flush()
end

function Microphone.RecordData(Device, SoundData)
	local MicRecordMessage = ("")
		:WriteShort(CONST.NET.PLAYERMIC)
		:WriteShort(SoundData:getSampleCount())
		:WriteShort(SoundData:getSampleRate())
		:WriteByte(SoundData:getBitDepth())
		:WriteByte(SoundData:getChannels())

	for i = 1, SoundData:getSampleCount() do
		local Sample = SoundData:getSample(i - 1)
		local UInt = Sample * 2147483648 + 2147483648
		MicRecordMessage = MicRecordMessage:WriteInt(UInt)
	end

	--Microphone.Peer:send(MicRecordMessage, 1, "reliable")
end

