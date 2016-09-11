local Path, PLAY2D, Language = ...

local LanguageObject = {}
local LanguageMT = {__index = LanguageObject}

function LanguageObject:Get(Code)
	
	if self.Translation[Code] then
		return self.Translation[Code]
	end
	
	local Translation = Language.CreateTranslationLink(self, Code)
	
	self.Translation[Code] = Translation
	
	return Translation
	
end

function Language.CreateLink(LanguageName)
	
	local self = {}
	
	self.Language = LanguageName
	self.Translation = {}
	
	return setmetatable(self, LanguageMT)
	
end