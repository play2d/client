function string.split(String, Delimiter)
	if type(String) == "string" then
		local Parts = {}
		local Positions = {}
		local Delimiter = type(Delimiter) == "string" and Delimiter or "%s"
		for Part, Position in string.gmatch(String, "([^"..Delimiter.."]+)()") do
			table.insert(Parts, Part)
			table.insert(Positions, Position)
		end
		return Parts, Positions
	end
end

function string.findany(String, Table)
	if type(String) == "string" then
		for k, Str in pairs(Table) do
			if type(Str) == "string" then
				local Find = string.find(String, Str)
				if Find then
					return Find, Str
				end
			end
		end
	end
end

function string:ReadByte()
	return self:byte(1), self:sub(2)
end

function string:ReadShort()
	return self:byte(1) + self:byte(2) * 256, self:sub(3)
end

function string:ReadInt24()
	return self:byte(1) + self:byte(2) * 256 + self:byte(3) * (256^2), self:sub(4)
end

function string:ReadInt()
	return self:byte(1) + self:byte(2) * 256 + self:byte(3) * (256^2) + self:byte(4) * (256^3), self:sub(5)
end

function string:ReadNumber()
	local ByteArray = ffi.new("unsigned char [8]")
	for i = 0, 7 do
		ByteArray[i], self = self:ReadByte()
	end
	
	local BitArray = ffi.new("bool [64]")
	for Index = 0, 7 do
		for Offset = 7, 0, -1 do
			local Bit = 2 ^ Offset
			if ByteArray[Index] >= Bit then
				ByteArray[Index] = ByteArray[Index] - Bit
				BitArray[Index * 8 + Offset] = true
			end
		end
	end
	
	local Exponent = 0
	for BitID = 1, 11 do
		if BitArray[BitID] then
			Exponent = Exponent + 2 ^ (BitID - 1)
		end
	end
	
	local Fraction = 0
	for BitID = 1, 51 do
		if BitArray[BitID + 12] then
			Fraction = Fraction + (1/2) ^ (BitID - 1)
		end
	end
	
	if BitArray[0] then
		Fraction = -Fraction
	end
	return Fraction * 2 ^ Exponent
end

function string:ReadFloat()
	local Integer, self = self:ReadInt()
	local Fraction = 0
	
	for ByteID = 1, 4 do
		local ByteMult, Byte = 256 ^ (ByteID - 1)
		
		Byte, self = self:ReadByte()
		for BitID = 8, 1, -1 do
			local Bit = 2 ^ (BitID - 1)
			if Byte >= Bit then
				Byte = Byte - Bit
				Fraction = Fraction + (1/Bit) * (1/ByteMult)
			end
		end
	end
	return Integer + Fraction, self:sub(9)
end

function string:ReadString(Length)
	return self:sub(1, Length), self:sub(Length + 1)
end

function string:ReadLine()
	local Find = self:find(string.char(13)) or self:find(string.char(10))
	if Find then
		return self:sub(1, Find - 1), self:sub(Find + 1)
	end
	return self, ""
end

function string:WriteByte(n)
	return self .. string.char(math.floor(n))
end

function string:WriteShort(n)
	local n = math.floor(n + 0.5)
	local n1 = (n % 256); n = (n - n1)/256
	return self .. string.char(n1) .. string.char(n % 256)
end

function string:WriteInt24(n)
	local n = math.floor(n + 0.5)
	local n1 = (n % 256); n = (n - n1)/256
	local n2 = (n % 256); n = (n - n2)/256
	return self .. string.char(n1) .. string.char(n2) .. string.char(n % 256)
end

function string:WriteInt(n)
	local n = math.floor(n + 0.5)
	local n1 = (n % 256); n = (n - n1)/256
	local n2 = (n % 256); n = (n - n2)/256
	local n3 = (n % 256); n = (n - n3)/256
	return self .. string.char(n1) .. string.char(n2) .. string.char(n3) .. string.char(n % 256)
end

function string:WriteNumber(n)
	local BitArray = ffi.new("bool [64]")
	if n < 0 then
		BitArray[0] = true
		n = math.floor(n)
	end
	
	-- math.frexp(n) = Fraction -> n = Fraction * 2 ^ Exponent
	local Fraction = math.frexp(n)
	
	-- n = Fraction * 2 ^ Exponent -> n/Fraction = 2 ^ Exponent
	-- log10(2^Exponent)/log10(2) = Exponent * log10(2) / log10(2) = Exponent
	local Exponent = math.log10(n/Fraction)/0.30102999566398 -- math.log10(2) = 0.30102999566398
	
	for BitID = 11, 1, -1 do
		local Bit = 2 ^ (BitID - 1)
		if Exponent >= Bit then
			Exponent = Exponent - Bit
			BitArray[BitID] = true
		end
	end
	
	for BitID = 1, 51 do
		if Fraction >= 1 then
			Fraction = Fraction - 1
			BitArray[BitID + 12] = true
		end
		Fraction = Fraction * 2
	end
	
	local ByteArray = ffi.new("unsigned char [8]")
	for Index = 0, 7 do
		for Offset = 0, 7 do
			local Bit = BitArray[Index * 8 + Offset]
			if Bit then
				ByteArray[Index] = ByteArray[Index] + 2 ^ Offset 
			end
		end
	end
	return self .. ffi.string(ByteArray, 8)
end

function string:WriteFloat(n)
	local Integer, Fraction = math.modf(n)
	
	self = self:WriteInt(Integer)
	for ByteID = 1, 4 do
		local Byte = 0
		for BitID = 1, 8 do
			if Fraction >= 1 then
				Fraction = Fraction - 1
				Byte = Byte + 2 ^ (BitID - 1)
			end
			Fraction = Fraction * 2
		end
		self = self:WriteByte(Byte)
	end
	return self
end

function string:WriteString(String)
	return self .. String
end

function string:WriteLine(Line)
	return self .. Line .. "\n"
end