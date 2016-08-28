local Path, PLAY2D = ...

local Translation = {}
local TranslationMT = {__index = Translation}

function TranslationMT:__tostring()
	return self.String:gsub("$(%a+)", self.Arguments)
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

local function CreateTranslation(String)
	
	local self = {}
	
	self.String = String
	self.Arguments = {}
	
	return setmetatable(self, TranslationMT)
end

local function CreateLanguage(Name)
	
	if PLAY2D.Lang[Name] then
		return PLAY2D.Lang[Name]
	end
	
	local self = {}
	
	self.Name = Name
	self.Translation = {}
	
	PLAY2D.Lang[Name] = self
	
	return self
	
end

local function LoadLanguages()
	PLAY2D.Lang = {}
	
	for Index, File in pairs(love.filesystem.getDirectoryItems("sys/language")) do
		
		-- Only take .txt files
		if File:sub(-4, -1) == ".txt" then
			
			-- The name of the language is the filename
			local Name = File:sub(1, -5)
			if #Name > 0 then
				
				local Language = CreateLanguage(Name)
				local Function, Error = loadfile("sys/language/"..File)
				if Error then
					
					-- Check syntax errors
					print("Language error: "..Error)
					
				else
					
					-- Initialize the language table
					local Translation = {}
					
					setfenv(Function, Translation)
					
					-- Check runtime errors
					local Ok, Error = pcall(Function)
					if not Ok then
						
						print("Language error: "..Error)
						
					end
					
					for Code, String in pairs(Translation) do
						
						Language.Translation[Code] = CreateTranslation(String)
						
					end
					
				end
				
			end
			
		end
		
	end
	
end

return {
	load = LoadLanguages,
	Create = CreateLanguage,
}