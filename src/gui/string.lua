local utf8 = require("utf8")

function string:utf8offset(i)
	
	if i then
		
		return utf8.offset(self, i)
		
	end
	
end

function string:utf8offset2(i)
	
	if i then
		
		if i < 0 then
			
			return 0
			
		elseif i > self:utf8len() then
			
			return self:utf8len()
			
		end
		
		local y = utf8.offset(self, i)
		local y2 = utf8.offset(self, i + 1)
		local Length = 1
		
		if y2 then
			
			Length = y2 - y
			
		end
		
		return y + Length - 1
		
	end
	
end

function string:utf8sub(i, j)
	
	return self:sub(self:utf8offset(i), self:utf8offset2(j))
	
end

function string:utf8len(i, j)
	
	return utf8.len(self, i or 1, j or -1)
	
end