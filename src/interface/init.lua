local Path, PLAY2D = ...
local Interface = {}

Interface.Desktop = PLAY2D.Require(Path.."/desktop", Interface)
Interface.Console = PLAY2D.Require(Path.."/console", Interface)
Interface.Friends = PLAY2D.Require(Path.."/friends", Interface)
Interface.Chat = PLAY2D.Require(Path.."/chat", Interface)
Interface.Help = PLAY2D.Require(Path.."/help", Interface)
Interface.Servers = PLAY2D.Require(Path.."/servers", Interface)
Interface.Options = PLAY2D.Require(Path.."/options", Interface)
Interface.Login = PLAY2D.Require(Path.."/login", Interface)
Interface.Quit = PLAY2D.Require(Path.."/quit", Interface)

function Interface.load()
	
	Interface.Language = PLAY2D.Commands.List["language"]:GetLink()
	
	Interface.Desktop.load()
	Interface.Console.load()
	Interface.Friends.load()
	Interface.Chat.load()
	Interface.Help.load()
	Interface.Servers.load()
	Interface.Options.load()
	Interface.Login.load()
	Interface.Quit.load()
	
	Interface.load = nil
	
end

return Interface
