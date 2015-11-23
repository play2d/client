function table.copy(t)
	local Copy = {}
	for k, v in pairs(t) do
		local ValueType = type(v)
		if ValueType == "table" then
			Copy[k] = table.copy(v)
		elseif ValueType == "function" then
			local Success, Func = pcall(string.dump, v)
			if Success then
				Copy[k] = loadstring(Func)
			else
				Copy[k] = v
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