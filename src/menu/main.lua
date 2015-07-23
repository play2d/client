game.ui = {}

local function InitializeMainMenu()
	game.ui.Desktop = gui.CreateDesktop(config["cl_gui"])
	
	game.ui.Console = gui.CreateLabel("Console", 20, 200, game.ui.Desktop)
	game.ui.Console:SetColor("Text", 255, 255, 255, 255)
end

Hook.Add("load", InitializeMainMenu)