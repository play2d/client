Core.Microphone = {}

local Path = ...
local Microphone = Core.Microphone
local mic = require("src.love-microphone")

function Microphone.Load()
	Microphone.Device = mic.openDevice(nil, nil, 0.1)
	Microphone.Source = mic.newQueueableSource()
	Microphone.Device:setDataCallback(Microphone.RecordData)
	Microphone.Device:start()
end

function Microphone.Update()
	Microphone.Device:poll()
end

function Microphone.RecordData(Device, SoundData)
	Microphone.Source:queue(SoundData)
	Microphone.Source:play()
end