function string.split(String, Delimiter)
	if type(String) == "string" then
		local Parts = {}
		local Positions = {}
		local Delimiter = type(Delimiter) == "string" and Delimiter or "%s"
		for Part, Position in gmatch(String, "([^"..Delimiter.."]+)()") do
			insert(Parts, Part)
			insert(Positions, Position)
		end
		return Parts, Positions
	end
end
setfenv(string.split, {type = type, gmatch = string.gmatch, insert = table.insert})

function string.findany(String, Table)
	if type(String) == "string" then
		for k, Str in pairs(Table) do
			if type(Str) == "string" then
				local Find = find(String, Str)
				if Find then
					return Find, Str
				end
			end
		end
	end
end
setfenv(string.findany, {find = string.find, type = type, pairs = pairs})

function string:ReadByte()
	if #self >= 1 then
		return self:byte(1), self:sub(2)
	end
end

function string:ReadShort()
	if #self >= 2 then
		return self:byte(1) + self:byte(2) * 256, self:sub(3)
	end
end

function string:ReadInt24()
	if #self >= 3 then
		return self:byte(1) + self:byte(2) * 256 + self:byte(3) * 65536, self:sub(4)
	end
	return 0
end

function string:ReadInt()
	if #self >= 4 then
		return self:byte(1) + self:byte(2) * 256 + self:byte(3) * 65536 + self:byte(4) * 16777216, self:sub(5)
	end
	return 0
end

function string:ReadNumber()
	if #self >= 8 then
		local ByteArray = {}
		for i = 0, 7 do
			ByteArray[i], self = self:ReadByte()
		end
		
		local BitArray = {}
		for Index = 0, 7 do
			local Bit = 128
			for Offset = 7, 0, -1 do
				if ByteArray[Index] >= Bit then
					ByteArray[Index] = ByteArray[Index] - Bit
					BitArray[Index * 8 + Offset] = true
				end
				Bit = Bit / 2
			end
		end
		
		local Exponent = 0
		local Bit = 1
		for BitID = 1, 11 do
			if BitArray[BitID] then
				Exponent = Exponent + Bit
			end
			Bit = Bit * 2
		end
		
		local Fraction = 0
		local Bit = 1
		for BitID = 1, 52 do
			if BitArray[BitID + 11] then
				Fraction = Fraction + Bit
			end
			Bit = Bit / 2
		end
		
		if BitArray[0] then
			Fraction = -Fraction
		end
		return Fraction * 2 ^ Exponent
	end
	return 0
end

function string:ReadFloat()
	if #self >= 8 then
		local Integer, self = self:ReadInt()
		local Fraction = 0
		
		local ByteMult = 1
		for ByteID = 1, 4 do
			local Bit, Byte = 128

			Byte, self = self:ReadByte()
			for BitID = 8, 1, -1 do
				if Byte >= Bit then
					Byte = Byte - Bit
					Fraction = Fraction + (1/Bit) * ByteMult
				end
				Bit = Bit / 2
			end
			ByteMult = ByteMult / 256
		end
		return Integer + Fraction, self:sub(9)
	end
	return 0
end

function string:ReadString(Length)
	return self:sub(1, Length), self:sub(Length + 1)
end

function string:ReadLine()
	local Find = self:find(char(13)) or self:find(char(10))
	if Find then
		return self:sub(1, Find - 1), self:sub(Find + 1)
	end
	return self, ""
end
setfenv(string.ReadLine, {char = string.char})

function string:WriteByte(n)
	return self .. char(floor(n))
end
setfenv(string.WriteByte, {char = string.char, floor = math.floor})

function string:WriteShort(n)
	local n = floor(n + 0.5)
	local n1 = (n % 256); n = (n - n1)/256
	return self .. char(n1) .. char(n % 256)
end
setfenv(string.WriteShort, {char = string.char, floor = math.floor})

function string:WriteInt24(n)
	local n = floor(n + 0.5)
	local n1 = (n % 256); n = (n - n1)/256
	local n2 = (n % 256); n = (n - n2)/256
	return self .. char(n1) .. char(n2) .. char(n % 256)
end
setfenv(string.WriteInt24, {char = string.char, floor = math.floor})

function string:WriteInt(n)
	local n = floor(n + 0.5)
	local n1 = (n % 256); n = (n - n1)/256
	local n2 = (n % 256); n = (n - n2)/256
	local n3 = (n % 256); n = (n - n3)/256
	return self .. char(n1) .. char(n2) .. char(n3) .. char(n % 256)
end
setfenv(string.WriteInt, {char = string.char, floor = math.floor})

function string:WriteNumber(n)
	local BitArray = {}
	if n < 0 then
		BitArray[0] = true
		n = -n
	end
	
	-- math.frexp(n) = Fraction -> n = Fraction * 2 ^ Exponent
	local Fraction = frexp(n)
	
	-- n = Fraction * 2 ^ Exponent -> n/Fraction = 2 ^ Exponent
	-- log10(2^Exponent)/log10(2) = Exponent * log10(2) / log10(2) = Exponent
	local Exponent = log(n/Fraction)/0.30102999566398 -- math.log10(2) = 0.30102999566398
	
	local Bit = 1024
	for BitID = 11, 1, -1 do
		if Exponent >= Bit then
			Exponent = Exponent - Bit
			BitArray[BitID] = true
		end
		Bit = Bit / 2
	end
	
	for BitID = 1, 52 do
		if Fraction >= 1 then
			Fraction = Fraction - 1
			BitArray[BitID + 11] = true
		end
		Fraction = Fraction * 2
	end
	
	local ByteArray = {[0] = 0, 0, 0, 0, 0, 0, 0, 0}
	for Index = 0, 7 do
		local Bit = 1
		for Offset = 0, 7 do
			local BitBoolean = BitArray[Index * 8 + Offset]
			if BitBoolean then
				ByteArray[Index] = ByteArray[Index] + Bit
			end
			Bit = Bit * 2
		end
	end
	return self .. char(ByteArray[0]) .. char(ByteArray[1]) .. char(ByteArray[2]) .. char(ByteArray[3]) .. char(ByteArray[4]) .. char(ByteArray[5]) .. char(ByteArray[6]) .. char(ByteArray[7])
end
setfenv(string.WriteNumber, {frexp = math.frexp, log = math.log10, char = string.char})

function string:WriteFloat(n)
	local Integer, Fraction = modf(n)
	
	self = self:WriteInt(Integer)
	for ByteID = 1, 4 do
		local Byte = 0
		local Bit = 1
		for BitID = 1, 8 do
			if Fraction >= 1 then
				Fraction = Fraction - 1
				Byte = Byte + Bit
			end
			Fraction = Fraction * 2
			Bit = Bit * 2
		end
		self = self:WriteByte(Byte)
	end
	return self
end
setfenv(string.WriteFloat, {modf = math.modf})

function string:WriteString(String)
	return self .. String
end

function string:WriteLine(Line)
	return self .. Line .. "\n"
end