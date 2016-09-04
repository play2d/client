local Path, PLAY2D = ...
local Commands = {}

local Command = {}
local CommandMT = {__index = Command}

Command.Category = ""

function Command:Execute(Terminal)
end

function Command:GenerateConfiguration()
end

function Command:GetString()
end

function Command:GetInt()
end

function Command:GetNumber()
end

function Command:Set(Value)
end

function Commands.Create(Name)
	
	local self = {}
	
	Commands.List[Name] = self
	
	return self
	
end

function Commands.load()
	Commands.List = {}
	
	for Index, File in pairs(love.filesystem.getDirectoryItems("src/commands")) do
		
		if File ~= "init.lua" then
			
			if File:sub(-4, -1) == ".lua" then
				
				local Command = File:sub(1, -5)
				
				if #Command > 0 then
					
					local Object = Commands.Create(Command)
					local Ok, ErrorOrFunction = pcall(love.filesystem.load, "src/commands/"..File)
					
					if Ok then
						
						local Ok, Error = pcall(ErrorOrFunction, Object)
						
						if not Ok then
							
							print("Command runtime error ("..Command.."): "..Error)
							
						end
						
					else
						
						print("Command syntax error ("..Command.."): "..ErrorOrFunction)
						
					end
					
				end
				
			end
			
		end
		
	end
	
	Commands.load = nil
end

return Commands