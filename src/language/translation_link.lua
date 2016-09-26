local Path, PLAY2D, Language = ...
local Translation = {}
local TranslationMT = {__index = Translation}

function TranslationMT:__tostring()
	
	local Language = Language.List[self.Language.Language]
	
	if Language then
		
		if Language.Translation[self.Code] then
			
			return Language.Translation[self.Code].String:gsub("$(%a+)", self.Arguments)
			
		end
		
	end
	
	return self.Code
	
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

function Language.CreateTranslationLink(LanguageLink, Code)
	
	local self = {}
	
	self.Language = LanguageLink
	self.Code = Code
	self.Arguments = {}
	
	return setmetatable(self, TranslationMT)
	
end

return Translation