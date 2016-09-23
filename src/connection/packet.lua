local Path, PLAY2D, Connection = ...

local Packet = {}
local PacketMT = {__index = Packet}

Packet.Data = ""
Packet.Position = 1

function Connection.CreatePacket(Data)
	
	local self = {
		Data = Data
	}
	
	return setmetatable(self, PacketMT)
	
end

function Packet:Size()
	
	return #self.Data
	
end

function Packet:Seek(Position)
	
	self.Position = Position
	
	return self
	
end

function Packet:Move(Bytes)
	
	self.Position = self.Position + Bytes
	
	return self
	
end

function Packet:Read(Size)
	
	local Data = self.Data:sub(self.Position, self.Position + Size - 1)
	
	self:Move(Size)
	
	return Data
	
end

function Packet:Write(Data)
	
	self.Data = self.Data .. Data
	
	self:Move(#Data)
	
	return self
	
end

function Packet:WriteByte(n)
	
	return self:Write(string.char(n))
	
end

function Packet:ReadByte()
	
	return self:Read(1):byte()
	
end

function Packet:WriteInt16(n)
	
	local Byte = {}
	
	Byte[1] = n % 256; n = (n - Byte[1]) / 256
	Byte[2] = n
	
	return self:Write( string.char(Byte[1]) .. string.char(Byte[2]) )
	
end

function Packet:ReadInt16()
	
	local Data = self:Read(2)
	
	return Data:byte(1) + Data:byte(2) * 256
	
end

function Packet:WriteInt24(n)
	
	local Byte = {}
	
	Byte[1] = n % 256; n = (n - Byte[1]) / 256
	Byte[2] = n % 256; n = (n - Byte[2]) / 256
	Byte[3] = n
	
	return self:Write(string.char(Byte[1]) .. string.char(Byte[2]) .. string.char(Byte[3]))
	
end

function Packet:ReadInt24()
	
	local Data = self:Read(3)
	
	return Data:byte(1) + Data:byte(2) * 256 + Data:byte(3) * 256 * 256
	
end

function Packet:WriteInt(n)
	
	local Byte = {}
	
	Byte[1] = n % 256; n = (n - Byte[1]) / 256
	Byte[2] = n % 256; n = (n - Byte[2]) / 256
	Byte[3] = n % 256; n = (n - Byte[3]) / 256
	Byte[4] = n
	
	return self:Write(string.char(Byte[1]) .. string.char(Byte[2]) .. string.char(Byte[3]) .. string.char(Byte[4]))
	
end

function Packet:ReadInt()
	
	local Data = self:Read(4)
	
	return Data:byte(1) + Data:byte(2) * 256 + Data:byte(3) * 256 * 256 + Data:byte(4) * 256 * 256 * 256
	
end

function Packet:WriteFloat(n)
	
	local BitArray = {}
	
	if n < 0 then
		
		BitArray[1] = true
		n = -n
		
	end
	
	local Fraction = math.frexp(n)
	local Exponent = math.log10(n / Fraction) / math.log10(2)
	
	local Bit = 128
	for b = 9, 2, -1 do
		
		if Exponent >= Bit then
			
			Exponent = Exponent - Bit
			BitArray[b] = true
			
		end
		
		-- Multiplying by 0.5 is cheaper than dividing by 2
		Bit = Bit * 0.5
		
	end
	
	for b = 10, 32 do
	
		if Fraction >= 1 then
			
			Fraction = Fraction - 1
			BitArray[b] = true
			
		end
		
		Fraction = Fraction * 2
		
	end
	
	local Byte = {0, 0, 0, 0}
	for i = 1, 4 do
		
		local Bit = 1
		local byteIndex = (i - 1) * 8
		
		for o = 1, 8 do
			
			local Bool = BitArray[ byteIndex + o ]
			
			if Bool then
				
				Byte[i] = Byte[i] + Bit
				
			end
			
			Bit = Bit * 2
			
		end
		
	end
	
	return self:Write(string.char(Byte[1]) .. string.char(Byte[2]) .. string.char(Byte[3]) .. string.char(Byte[4]))
	
end

function Packet:ReadFloat()
	
	local Data = self:Read(4)
	
	local Byte = {Data:byte(1), Data:byte(2), Data:byte(3), Data:byte(4)}
	local BitArray = {}
	
	for i = 1, 4 do
		
		local Bit = 128
		local byteIndex = (i - 1) * 8
		
		for b = 8, 1, -1 do
			
			if Byte[i] >= Bit then
				
				Byte[i] = Byte[i] - Bit
				BitArray[byteIndex + b] = true
				
			end
			
			-- Multiplying by 0.5 is cheaper than dividing by 2
			Bit = Bit * 0.5
			
		end
		
	end
	
	local Exponent = 0
	local Bit = 1
	
	for b = 2, 9 do
		
		if BitArray[b] then
			
			Exponent = Exponent + Bit
			
		end
		
		Bit = Bit * 2
		
	end
	
	local Fraction = 0
	local Bit = 1
	
	for b = 10, 32 do
		
		if BitArray[b] then
			
			Fraction = Fraction + Bit
			
		end
		
		Bit = Bit * 0.5
		
	end
	
	if BitArray[1] then
		
		Fraction = -Fraction
		
	end
	
	return Fraction * 2 ^ Exponent
	
end

function Packet:WriteDouble(n)
	
	local BitArray = {}
	
	if n < 0 then
		
		BitArray[1] = true
		n = -n
		
	end
	
	local Fraction = math.frexp(n)
	local Exponent = math.log10(n / Fraction) / math.log10(2)
	
	local Bit = 1024
	for b = 12, 2, -1 do
		
		if Exponent >= Bit then
			
			Exponent = Exponent - Bit
			BitArray[b] = true
			
		end
		
		-- Multiplying by 0.5 is cheaper than dividing by 2
		Bit = Bit * 0.5
		
	end
	
	for b = 13, 64 do
	
		if Fraction >= 1 then
			
			Fraction = Fraction - 1
			BitArray[b] = true
			
		end
		
		Fraction = Fraction * 2
		
	end
	
	local Byte = {0, 0, 0, 0, 0, 0, 0, 0}
	for i = 1, 8 do
		
		local Bit = 1
		local byteIndex = (i - 1) * 8
		
		for o = 1, 8 do
			
			local Bool = BitArray[ byteIndex + o ]
			
			if Bool then
				
				Byte[i] = Byte[i] + Bit
				
			end
			
			Bit = Bit * 2
			
		end
		
	end
	
	return self:Write(string.char(Byte[1]) .. string.char(Byte[2]) .. string.char(Byte[3]) .. string.char(Byte[4]) .. string.char(Byte[5]) .. string.char(Byte[6]) .. string.char(Byte[7]) .. string.char(Byte[8]))
	
end

function Packet:ReadDouble()
	
	local Data = self:Read(8)
	
	local Byte = {Data:byte(1), Data:byte(2), Data:byte(3), Data:byte(4), Data:byte(5), Data:byte(6), Data:byte(7), Data:byte(8)}
	local BitArray = {}
	
	for i = 1, 8 do
		
		local Bit = 128
		local byteIndex = (i - 1) * 8
		
		for b = 8, 1, -1 do
			
			if Byte[i] >= Bit then
				
				Byte[i] = Byte[i] - Bit
				BitArray[byteIndex + b] = true
				
			end
			
			-- Multiplying by 0.5 is cheaper than dividing by 2
			Bit = Bit * 0.5
			
		end
		
	end
	
	local Exponent = 0
	local Bit = 1
	
	for b = 2, 12 do
		
		if BitArray[b] then
			
			Exponent = Exponent + Bit
			
		end
		
		Bit = Bit * 2
		
	end
	
	local Fraction = 0
	local Bit = 1
	
	for b = 13, 64 do
		
		if BitArray[b] then
			
			Fraction = Fraction + Bit
			
		end
		
		Bit = Bit * 0.5
		
	end
	
	if BitArray[1] then
		
		Fraction = -Fraction
		
	end
	
	return Fraction * 2 ^ Exponent
	
end

function Packet:WriteLine(String)
	
	return self:Write(String:gsub("\n", "") .. "\n")
	
end

function Packet:ReadLine()
	
	local Break = self.Data:find("\n", self.Position)
	
	if Break then
		
		return self:Read(Break - self.Position + 1):sub(1, -2)
		
	end
	
	return self:Read(#self.Data - self.Position + 1)
	
end

function Packet:WriteString(Str)
	
	return self:Write(Str)
	
end

function Packet:ReadString(Length)
	
	return self:Read(Length)
	
end

return Packet