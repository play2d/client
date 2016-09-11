local Command = ...

Command.Category = "Multiplayer"

local Name = "Player"

function Command:Execute(Terminal, String)
	
	Name = tostring(String)
	
end

function Command:GenerateConfiguration()
	
	return "name "..Name
	
end

function Command:GetString()
	
	return Name
	
end

function Command:Set(String)
	
	Name = String
	
end