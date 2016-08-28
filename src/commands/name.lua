local Command = ...

Command.Category = "Multiplayer"

local Name = "Player"

function Command.Execute(Terminal, NewName)
	Name = NewName
end

function Command.GenerateConfiguration()
	return "name "..Name
end

function Command:GetString()
	return Name
end