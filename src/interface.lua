Interface = {}

require("src.menu.main")
require("src.menu.console")
require("src.menu.servers")
require("src.menu.options")
require("src.menu.quit")

function Interface.Load()
	Interface.InitializeMainMenu()
	Interface.InitializeConsoleMenu()
	Interface.InitializeServersMenu()
	Interface.InitializeOptionsMenu()
	Interface.InitializeQuitMenu()
	
	Interface.Load = nil
end