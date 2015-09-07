game.ui = {}

require("src.menu.main")
require("src.menu.console")
require("src.menu.servers")
require("src.menu.options")

function game.ui.load()
	game.ui.InitializeMainMenu()
	game.ui.InitializeConsoleMenu()
	game.ui.InitializeServersMenu()
	Options.InitializeMenu()
	
	game.ui.load = nil
end