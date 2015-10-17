function string.split(String, Delimiter)
	local Parts = {}
	local Positions = {}
	local Delimiter = Delimiter or "%s"
	for Part, Position in string.gmatch(String, "([^"..Delimiter.."]+)()") do
		table.insert(Parts, Part)
		table.insert(Positions, Position)
	end
	return Parts, Positions
end

function string:ReadByte()
	return self:byte(), self:sub(2)
end

function string:ReadShort()
	return self:byte() + self:byte(2) * 256, self:sub(3)
end

function string:ReadInt()
	return self:byte() + self:byte(2) * 256 + self:byte(3) * 65536 + self:byte(4) * 16777216, self:sub(5)
end