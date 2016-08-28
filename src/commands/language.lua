local Command = ...

Command.Category = "Local"

local Language = "English"

function Command.Execute(Terminal, NewLanguage)
	Language = NewLanguage
end

function Command.GenerateConfiguration()
	return "language "..Language
end

function Command:GetString()
	return Language
end