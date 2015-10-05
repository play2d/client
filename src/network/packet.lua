local TPacket = {}
local TPacketMetatable = {__index = TPacket}
TPacket.Position = 1
TPacket.Type = "Packet"
TPacket.TypeID = 0
TPacket.MaxSize = 800
TPacket.DistID = 5000

function Network.CreatePacket(TypeID)
	local Packet = {
		Buffer = "",
		TypeID = TypeID,
	}
	return setmetatable(Packet, TPacketMetatable)
end

function TPacket:GenerateCompression()
	-- Should return: uses zlib, uses fragmentation
	if self.Fragment then
		return self.IsCompressed, true
	elseif self.Compression then
		return self.IsCompressed, false
	end
	
	if #self.Buffer == 0 then
		self.Compression = ""
		self.IsCompressed = nil
		return false, false
	end

	if zlib then
		-- Attempt to compress
		local Success, Compression = pcall(zlib.deflate, self.Buffer, {}, nil, "zlib", 9)
		if Success then
			self.IsCompressed = true
			Compression = table.concat(Compression)

			if #Compression > self.MaxSize then
				local Fragments = {}
				for i = 1, #Compression, self.MaxSize do
					table.insert(Fragments, Compression:sub(i, i + self.MaxSize - 1))
				end
				self.Fragment = Fragments
				self.FragmentCount = #Fragments
				return true, true
			end
			self.Compression = Compression
			return true, false
		end
	end
	
	-- Failed to compress, check if we can make fragments
	if #self.Buffer > self.MaxSize then
		local Fragments = {}
		for i = 1, #self.Buffer, self.MaxSize do
			table.insert(Fragments, self.Buffer:sub(i, i + self.MaxSize - 1))
		end
		self.Fragment = Fragments
		self.FragmentCount = #Fragments
		return false, true
	end
	
	self.Compression = self.Buffer
	return false, false
end

function TPacket:GetModifier()
	local ByteModifier = 0
	if self.Reply or self.Confirm then
		ByteModifier = ByteModifier + 1
	end
	if self.Reliable then
		ByteModifier = ByteModifier + 2
	end
	if self.Sequenced then
		ByteModifier = ByteModifier + 4
	end
	if self.First then
		ByteModifier = ByteModifier + 8
	end
	if self.Fragment or self.Confirm then
		ByteModifier = ByteModifier + 64
	end
	if self.IsCompressed then
		ByteModifier = ByteModifier + 128
	end
	return ByteModifier
end

function TPacket:IsAfter(Packet)
	if Packet.ID < self.ID then
		return Packet.ID >= self.ID - TPacket.DistID
	end
	return Packet.ID - 65536 >= self.ID - TPacket.DistID
end

function TPacket:IsRightAfter(Packet)
	if (Packet.ID % 65535) + 1 == self.ID then
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