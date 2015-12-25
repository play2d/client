function table.copy(t, C, C2)
	local Copy = {}
	local C = C or {}
	local C2 = C2 or {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			if v == t then
				Copy[k] = Copy
			elseif C[v] then
				Copy[k] = C[v]
			elseif C2[v] then
				Copy[k] = Copy
			else
				C2[v] = true
				Copy[k] = table.copy(v, C, C2)
				C2[v] = nil
				C[v] = Copy[k]
			end
		else
			Copy[k] = v
		end
	end
	return Copy
end

function table.count(t)
	local Count = 0
	for k, v in pairs(t) do
		Count = Count + 1
	end
	return Count
end

function table.find(t, v)
	for Key, Value in pairs(t) do
		if Value == v then
			return Key
		end
	end
end