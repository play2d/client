local TPacket = {}
local TPacketMetatable = {__index = TPacket}
TPacket.Type = "Packet"
TPacket.MaxSize = 500
TPacket.DistID = 500

function Network.CreatePacket()
	local Packet = {
		Buffer = "",
		Position = 1,
	}
	return setmetatable(Packet, TPacketMetatable)
end

function TPacket:GenerateBuffer()
	-- Should return: Compressed string, uses zlib, is fragmented
	
	-- Check that the size is not higher than self.MaxSize, otherwise split it into fragments of self.MaxSize each one
	-- Check that zlib compression is available
	if zlib then
		local Success, Compression = pcall(zlib.deflate, self.Buffer, {}, self.MaxSize, "zlib", 9)
		if Success then
			if #Compression > 1 then
				self.Part = Compression
				return nil, true, true
			else
				return table.concat(Compression), true, false
			end
		end
	end
	
	if #self.Buffer > self.MaxSize then
		local Compression = {}
		for i = 1, #self.Buffer, self.MaxSize + 1 do
			local Part = self.Buffer:sub(i, i + self.MaxSize)
			
			table.insert(Compression, Part)
		end
		self.Part = Compression
		return nil, false, true
	end
	
	return self.Buffer, false, false
end

function TPacket:IsAfter(Packet)
	if Packet.ID < self.ID then
		return Packet.ID >= self.ID - TPacket.DistID
	end
	return Packet.ID - 65536 >= self.ID - TPacket.DistID
end

function TPacket:IsRightAfter(Packet)
	if (Packet.ID + 1) % 65536 == self.ID then
		return true
	end
end

function TPacket:ReadByte()
	local Byte = self.Buffer:sub(self.Position):ReadByte()
	self.Position = self.Position + 1
	return Byte
end

function TPacket:ReadShort()
	local Short = self.Buffer:sub(self.Position):ReadShort()
	self.Position = self.Position + 2
	return Short
end

function TPacket:ReadInt()
	local Int = self.Buffer:sub(self.Position):ReadInt()
	self.Position = self.Position + 4
	return Int
end

function TPacket:ReadString(Length)
	local String = self.Buffer:sub(self.Position):ReadString(Length)
	self.Position = self.Position + Length
	return String
end

function TPacket:ReadLine()
	local String = self.Buffer:sub(self.Position):ReadLine()
	self.Position = self.Position + #String + 1
	return String
end

function TPacket:WriteByte(n)
	self.Buffer = self.Buffer:WriteByte(n)
end

function TPacket:WriteShort(n)
	self.Buffer = self.Buffer:WriteShort(n)
end

function TPacket:WriteInt(n)
	self.Buffer = self.Buffer:WriteInt(n)
end

function TPacket:WriteString(String)
	self.Buffer = self.Buffer:WriteString(String)
end

function TPacket:WriteLine(String)
	self.Buffer = self.Buffer:WriteLine(String)
end