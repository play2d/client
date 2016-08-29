local Path, PLAY2D = ...
local Interface = {}

Interface.Desktop = PLAY2D.Require("interface/Desktop", Interface)
Interface.Servers = PLAY2D.Require("interface/Servers", Interface)
Interface.Options = PLAY2D.Require("interface/Options", Interface)
Interface.Quit = PLAY2D.Require("interface/Quit", Interface)

function Interface.load()
	
	Interface.Language = PLAY2D.Commands.List["language"]:GetLink()
	
	Interface.Desktop.load()
	Interface.Servers.load()
	Interface.Options.load()
	Interface.Quit.load()
	
	Interface.load = nil
	
end

return Interface