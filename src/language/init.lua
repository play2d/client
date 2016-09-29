local Path, PLAY2D = ...
local Language = {}

Language.Translation = PLAY2D.Require(Path.."/translation", Language)
Language.Language = PLAY2D.Require(Path.."/language", Language)

function Language.load()
	
	Language.List = {}
	
	for Index, File in pairs(love.filesystem.getDirectoryItems("sys/language")) do
		
		-- Only take .txt files
		if File:sub(-4, -1) == ".txt" then
			
			-- The name of the language is the filename
			local Name = File:sub(1, -5)
			if #Name > 0 then
				
				local LanguageObject = Language.Create(Name)
				local Ok, ErrorOrFunction = pcall(love.filesystem.load, "sys/language/"..File)
				
				if Ok then
					
					-- Initialize the language table
					local Translation = {}
					
					setfenv(ErrorOrFunction, Translation)
					
					-- Check runtime errors
					local Ok, Error = pcall(ErrorOrFunction)
					if not Ok then
						
						print("Language error: "..Error)
						
					end
					
					for Code, String in pairs(Translation) do
						
						LanguageObject.Translation[Code] = Language.CreateTranslation(String)
						
					end
				
				else
					
					-- Check syntax errors
					print("Language error: "..ErrorOrFunction)
					
				end
				
			end
			
		end
		
	end
	
	Language.load = nil
	
end

return Language