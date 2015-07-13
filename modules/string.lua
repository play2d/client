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