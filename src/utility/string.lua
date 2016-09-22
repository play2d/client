function string:debug()
	
	local ByteArray = ""
	
	for i = 1, #self do
		
		ByteArray = ByteArray .. string.byte(self, i) .. ","
		
	end
	
	return "{" .. ByteArray:sub(1, -2) .. "}"
	
end