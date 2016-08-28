local Path, PLAY2D = ...
local Configuration = {}

function Configuration.load()
	
	PLAY2D.Console = PLAY2D.Terminal.Create(PLAY2D.Commands.List)
	
	local File = io.open("sys/config.cfg", "r")
	
	if File then
	
		local Count = 0
		
		for Line in File:lines() do
			
			if Line:sub(1, 2) ~= "//" then
				
				if PLAY2D.Console:Execute(Line) then
					
					print("Command error (line "..Count.."): "..PLAY2D.Console.Error)
					
				end
				
			end
			
			Count = Count + 1
		end
		
		File:close()
	
	else
		
		error('"sys/config.cfg" is missing, cannot start the game without the configuration file')
		
	end
	
	Configuration.load = nil
end

function Configuration.save()
	
	local File = io.open("sys/config.cfg", "w")
	
	if File then
		
		local Category = {}
		
		for Name, Command in pairs(PLAY2D.Commands.List) do
			
			local Configuration = Command.GenerateConfiguration()
			
			if Configuration then
			
				if Command.Category and #Command.Category > 0 then
					
					if Category[Command.Category] then
						
						Category[Command.Category] = Category[Command.Category] .. "\n" .. Configuration
						
					else
						
						Category[Command.Category] = Configuration
						
					end
					
				elseif Category["Other"] then
					
					Category["Other"] = Category["Other"] .. "\n" .. Configuration
					
				else
					
					Category["Other"] = Configuration
					
				end
				
			end
			
		end
		
		for CategoryName, ConfigurationString in pairs(Category) do
			
			File:write("// "..CategoryName.."\n")
			File:write(ConfigurationString)
			
		end
		
		File:close()
		
	else
		
		print('Failed to write on "sys/config.cfg"')
		
	end
	
end

return Configuration