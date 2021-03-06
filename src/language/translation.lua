local Path, PLAY2D, Language = ...
local Translation = {}
local TranslationMT = {__index = Translation}

function TranslationMT:__tostring()
	
	return self.String:gsub("$(%w+)", self.Arguments)
	
end

function TranslationMT:__len()
	
	return #tostring(self)
	
end

function TranslationMT:__concat(String)
	
	return tostring(self) .. tostring(String)
	
end

function Translation:utf8offset(...)
	
	return tostring(self):utf8offset(...)
	
end

function Translation:utf8offset2(...)
	
	return tostring(self):utf8offset2(...)
	
end

function Translation:utf8sub(...)
	
	return tostring(self):utf8sub(...)
	
end

function Translation:utf8len(...)
	
	return tostring(self):utf8len(...)
	
end

function Language.CreateTranslation(String)
	
	local self = {}
	
	self.String = String
	self.Arguments = {}
	
	return setmetatable(self, TranslationMT)
	
end

return Translation