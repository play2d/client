function game.ui.OpenOptionsMenu()
	game.ui.Options.Hidden = nil
end

local function InitializeOptionsMenu()
	game.ui.Options = gui.CreateWindow(language.get("gui_label_options"), 120, 10, 670, 580, game.ui.Desktop, true)
	game.ui.Options.Hidden = true
	
	InitializeOptionsMenu = nil
end

Hook.Add("load", InitializeOptionsMenu)