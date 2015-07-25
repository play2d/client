function game.ui.OpenOptionsMenu()
	game.ui.Options.Window.Hidden = nil
end

local function InitializeOptionsMenu()
	game.ui.Options = {}
	game.ui.Options.Window = gui.CreateWindow(language.get("gui_label_options"), 120, 10, 670, 580, game.ui.Desktop, true)
	game.ui.Options.Window.Hidden = true
	
	game.ui.Options.Tab = gui.CreateTabber(10, 35, game.ui.Options.Window)
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_player"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_controls"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_game"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_graphics"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_sound"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_net"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_more"))
	
	function game.ui.Options.Tab:OnSelect(Index)
		game.ui.Options.Panels[self.Selected].Hidden = true
		game.ui.Options.Panels[Index].Hidden = nil
	end
	
	game.ui.Options.Panels = {}
	
	-- Player panel
	game.ui.Options.Panels[1] = gui.CreatePanel(language.get("gui_options_tab_player"), 10, 60, 650, 510, game.ui.Options.Window)
	gui.CreateLabel(language.get("gui_options_player_name"), 20, 30, game.ui.Options.Panels[1])
	
	game.ui.Options.NameField = gui.CreateTextfield(20, 50, 200, 20, game.ui.Options.Panels[1])
	game.ui.Options.NameField:SetText(config["name"])
	
	-- Controls panel
	game.ui.Options.Panels[2] = gui.CreatePanel(language.get("gui_options_tab_controls"), 10, 60, 650, 510, game.ui.Options.Window)
	
	-- Game panel
	game.ui.Options.Panels[3] = gui.CreatePanel(language.get("gui_options_tab_game"), 10, 60, 650, 510, game.ui.Options.Window)
	
	-- Graphics panel
	game.ui.Options.Panels[4] = gui.CreatePanel(language.get("gui_options_tab_graphics"), 10, 60, 650, 510, game.ui.Options.Window)
	
	-- Sound panel
	game.ui.Options.Panels[5] = gui.CreatePanel(language.get("gui_options_tab_sound"), 10, 60, 650, 510, game.ui.Options.Window)
	
	-- Net panel
	game.ui.Options.Panels[6] = gui.CreatePanel(language.get("gui_options_tab_net"), 10, 60, 650, 510, game.ui.Options.Window)
	
	-- More Panel
	game.ui.Options.Panels[7] = gui.CreatePanel(language.get("gui_options_tab_more"), 10, 60, 650, 510, game.ui.Options.Window)
	
	for i = 2, #game.ui.Options.Panels do
		game.ui.Options.Panels[i].Hidden = true
	end
	
	InitializeOptionsMenu = nil
end

Hook.Add("load", InitializeOptionsMenu)