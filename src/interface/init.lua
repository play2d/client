local Path, PLAY2D = ...
local Interface = {}

Interface.Desktop = PLAY2D.Require(Path.."/desktop", Interface)
Interface.Servers = PLAY2D.Require(Path.."/servers", Interface)
Interface.Options = PLAY2D.Require(Path.."/options", Interface)
Interface.Quit = PLAY2D.Require(Path.."/quit", Interface)

function Interface.load()
	
	Interface.Language = PLAY2D.Commands.List["language"]:GetLink()
	
	Interface.Desktop.load()
	Interface.Servers.load()
	Interface.Options.load()
	Interface.Quit.load()
	
	Interface.load = nil
	
end

return Interface
