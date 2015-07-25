function game.ui.OpenOptionsMenu()
	game.ui.Options.Hidden = nil
end

local function InitializeOptionsMenu()
	game.ui.Options = gui.CreateWindow(language.get("gui_label_options"), 120, 10, 670, 580, game.ui.Desktop, true)
	game.ui.Options.Hidden = true
	
	game.ui.OptionsTab = gui.CreateTabber(10, 35, game.ui.Options)
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_player"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_controls"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_game"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_graphics"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_sound"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_net"))
	game.ui.OptionsTab:AddItem(language.get("gui_options_tab_more"))
	
	function game.ui.OptionsTab:OnSelect(Index)
		game.ui.OptionsPanels[self.Selected].Hidden = true
		game.ui.OptionsPanels[Index].Hidden = nil
	end
	
	game.ui.OptionsPanels = {}
	
	-- Player panel
	game.ui.OptionsPanels[1] = gui.CreatePanel(language.get("gui_options_tab_player"), 10, 60, 650, 510, game.ui.Options)
	gui.CreateLabel(language.get("gui_options_player_name"), 20, 30, game.ui.OptionsPanels[1])
	
	-- Controls panel
	game.ui.OptionsPanels[2] = gui.CreatePanel(language.get("gui_options_tab_controls"), 10, 60, 650, 510, game.ui.Options)
	
	-- Game panel
	game.ui.OptionsPanels[3] = gui.CreatePanel(language.get("gui_options_tab_game"), 10, 60, 650, 510, game.ui.Options)
	
	-- Graphics panel
	game.ui.OptionsPanels[4] = gui.CreatePanel(language.get("gui_options_tab_graphics"), 10, 60, 650, 510, game.ui.Options)
	
	-- Sound panel
	game.ui.OptionsPanels[5] = gui.CreatePanel(language.get("gui_options_tab_sound"), 10, 60, 650, 510, game.ui.Options)
	
	-- Net panel
	game.ui.OptionsPanels[6] = gui.CreatePanel(language.get("gui_options_tab_net"), 10, 60, 650, 510, game.ui.Options)
	
	-- More Panel
	game.ui.OptionsPanels[7] = gui.CreatePanel(language.get("gui_options_tab_more"), 10, 60, 650, 510, game.ui.Options)
	
	for i = 2, #game.ui.OptionsPanels do
		game.ui.OptionsPanels[i].Hidden = true
	end
	
	InitializeOptionsMenu = nil
end

Hook.Add("load", InitializeOptionsMenu)