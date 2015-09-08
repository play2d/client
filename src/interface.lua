Interface = {}

require("src.menu.main")
require("src.menu.console")
require("src.menu.servers")
require("src.menu.options")

function Interface.Load()
	Interface.InitializeMainMenu()
	Interface.InitializeConsoleMenu()
	Interface.InitializeServersMenu()
	Interface.InitializeOptionsMenu()
	
	Interface.Load = nil
end