Core.Network.Protocol[CONST.NET.PLAYERMIC] = function (Peer, Message)
	local SampleCount, Message = Message:ReadShort()
	local SampleRate, Message = Message:ReadShort()
	local Bits, Message = Message:ReadByte()
	local Channels, Message = Message:ReadByte()
	
	local SoundData = love.sound.newSoundData(SampleCount, SampleRate, Bits, Channels)
	for i = 1, SampleCount do
		local Integer; Integer, Message = Message:ReadInt()
		local Sample = (tonumber(Integer) - 2147483648)/2147483648
		SoundData:setSample(i - 1, Sample)
	end
	
	love.audio.newSource(SoundData):play()
end