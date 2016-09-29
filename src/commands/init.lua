local Path, PLAY2D = ...
local Commands = {}

local Command = {}

Command.__index = Command
Command.Category = ""
Command.Value = 0

function Command:__tostring()
	
	return "Command [" .. self.Name .. "] = " .. tostring(self.Value)
	
end

function Command:Execute(Terminal)
	
end

function Command:GenerateConfiguration()
	
	return self.Name.." "..tostring(self.Value)
	
end

function Command:GetString()
	
	return tostring(self.Value)
	
end

function Command:GetInt()
	
	return math.floor(self.Value)
	
end

function Command:GetNumber()
	
	return self.Value
	
end

function Command:Set(Value)
	
	self.Value = Value
	
end

function Commands.Create(Name)
	
	local self = {}
	
	self.Name = Name
	
	Commands.List[Name] = self
	
	return setmetatable(self, Command)
	
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
						
						local Ok, Error = pcall(ErrorOrFunction, Object, PLAY2D)
						
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