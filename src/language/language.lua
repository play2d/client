local Path, PLAY2D, Language = ...

local LanguageObject = {}
local LanguageMT = {__index = LanguageObject}

function LanguageObject:Get(Code)
	return self.Translation[Code]
end

function Language.Create(Name)
	
	if Language.List[Name] then
		return Language.List[Name]
	end
	
	local self = {}
	
	self.Name = Name
	self.Translation = {}
	
	Language.List[Name] = self
	
	return setmetatable(self, LanguageMT)
	
end