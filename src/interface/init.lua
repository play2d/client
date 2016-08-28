local Path, PLAY2D = ...
local Interface = {}

Interface.Desktop = PLAY2D.Require("interface/Desktop", Interface)
Interface.Options = PLAY2D.Require("interface/Options", Interface)
Interface.Quit = PLAY2D.Require("interface/Quit", Interface)

function Interface.load()
	
	local LanguageName = PLAY2D.Commands.List["language"]:GetString()
	
	Interface.Language = PLAY2D.Lang[LanguageName]
	
	Interface.Desktop.load()
	Interface.Options.load()
	Interface.Quit.load()
	
	Interface.load = nil
end

return Interface