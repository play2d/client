function game.ui.OpenOptionsMenu()
	game.ui.Options.Hidden = nil
end

local function InitializeOptionsMenu()
	game.ui.Options = gui.CreateWindow(language.get("gui_label_options"), 120, 10, 670, 580, game.ui.Desktop, true)
	game.ui.Options.Hidden = true
	
	game.ui.OptionsTab = gui.CreateTabber(10, 30, game.ui.Options)
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_player"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_controls"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_game"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_graphics"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_sound"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_net"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_more"))
	
	InitializeOptionsMenu = nil
end

Hook.Add("load", InitializeOptionsMenu)