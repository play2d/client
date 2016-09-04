local Command = ...

Command.Category = "Local"

local Language = "English"
local Link = PLAY2D.Language.CreateLink(Language)

function Command:Execute(Terminal, String)
	Language = tostring(String)
	Link.Language = Language
end

function Command:GenerateConfiguration()
	return "language "..Language
end

function Command:GetString()
	return Language
end

function Command:Set(String)
	Language = tostring(String)
	Link.Language = Language
end

function Command:GetLink()
	return Link
end