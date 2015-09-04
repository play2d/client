game.Binds.List = {}

function game.ui.CreateBind(Text, Command)
	table.insert(game.Binds.List, {Text, Command})
end

function game.ui.OpenOptionsMenu()
	game.ui.Options.Window.Hidden = nil
end

function game.ReloadSpraylogos()
	game.Spraylogos = {}
	for Index, Item in pairs(love.filesystem.getDirectoryItems("logos")) do
		if love.filesystem.isFile("logos/"..Item) then
			local Image = love.graphics.newImage("logos/"..Item)
			if Image then
				table.insert(game.Spraylogos, {Index, Item, Image})
				if config["spraylogo"] then
					if Item == config["spraylogo"] then
						game.SetSpraylogo(#game.Spraylogos)
					end
				elseif not game.Spraylogo then
					game.SetSpraylogo(#game.Spraylogos)
				end
			end
		end
	end
end

function game.SetSpraylogo(Index)
	if Index <= 0 then
		Index = Index + #game.Spraylogos
	elseif Index > #game.Spraylogos then
		Index = Index - #game.Spraylogos
	end
	game.Spraylogo = game.Spraylogos[Index]
	game.ui.Options.Spraylogo.Image = game.Spraylogo[3]
	game.ui.Options.SpraylogoLabel:SetText(language.get2("gui_options_player_spraylogo", {SPRAYLOGO = game.Spraylogo[2] or ""}))
end

local function InitializeOptionsMenu()
	game.ui.Options = {}
	game.ui.Options.Window = gui.CreateWindow(language.get("gui_label_options"), 120, 10, 670, 580, game.ui.Desktop)
	game.ui.Options.Window.Hidden = true
	
	game.ui.Options.Tab = gui.CreateTabber(10, 35, game.ui.Options.Window)
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_player"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_controls"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_game"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_graphics"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_sound"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_net"))
	game.ui.Options.Tab:AddItem(language.get("gui_options_tab_more"))
	
	game.ui.Options.Okay = gui.CreateButton(language.get("gui_label_okay"), 450, 550, 100, 20, game.ui.Options.Window)
	function game.ui.Options.Okay:OnClick()
		-- Player name
		config["name"] = game.ui.Options.NameField:GetText()
		
		-- Spraylogo
		if game.Spraylogo then
			config["spraylogo"] = game.Spraylogo[2]
		end
		
		-- Relative to dir movement
		if game.ui.Options.MovementPanel.RadioButton == game.ui.Options.AbsMovementRadioButton then
			config["relativemovement"] = 0
		elseif game.ui.Options.MovementPanel.RadioButton == game.ui.Options.RelativeToDirRadioButton then
			config["relativemovement"] = 1
		end
		game.ui.Options.Window.Hidden = true
		
		-- Apply new binds
		for Bind, Key in pairs(game.NewBinds) do
			local PreviousBind = game.Binds.Find(Bind)
			if PreviousBind then
				config["bind"][PreviousBind] = nil
			end
			config["bind"][Key] = Bind
		end
		game.NewBinds = {}
		
		-- Apply the new language
		local SelectedLanguage = game.ui.LanguageBox:GetItem(game.ui.LanguageBox.Selected)
		if SelectedLanguage then
			config["cl_lang"] = SelectedLanguage
		end
		
		-- Save the configuration
		config.save()
	end
	
	game.ui.Options.Cancel = gui.CreateButton(language.get("gui_label_cancel"), 560, 550, 100, 20, game.ui.Options.Window)
	function game.ui.Options.Cancel:OnClick()
		-- Player name
		game.ui.Options.NameField:SetText(config["name"])
		
		-- Spraylogo
		game.Spraylogo = nil
		game.ReloadSpraylogos()
		
		-- Relative to dir movement
		if config["relativemovement"] == 0 then
			game.ui.Options.MovementPanel.RadioButton = game.ui.Options.AbsMovementRadioButton
		elseif config["relativemovement"] == 1 then
			game.ui.Options.MovementPanel.RadioButton = game.ui.Options.RelativeToDirRadioButton
		end
		game.ui.Options.Window.Hidden = true
		
		-- Delete the new binds and reload the listview with the current binds
		game.NewBinds = {}
		game.Binds.Reload()
		
		-- Reload the current language on it's combobox
		game.ui.LanguageBox:ClearItems()
		for Index, Item in pairs(language.list()) do
			game.ui.LanguageBox:SetItem(Index, Item)
			if config["cl_lang"] and config["cl_lang"] == Item then
				game.ui.LanguageBox:Select(Index)
			end
		end
	end
	
	function game.ui.Options.Tab:OnSelect(Index)
		game.ui.Options.Panels[self.Selected].Hidden = true
		game.ui.Options.Panels[Index].Hidden = nil
	end
	
	game.ui.Options.Panels = {}
	
	-- Player panel
	game.ui.Options.Panels[1] = gui.CreatePanel(language.get("gui_options_tab_player"), 10, 60, 650, 480, game.ui.Options.Window)
	gui.CreateLabel(language.get("gui_options_player_name"), 20, 30, game.ui.Options.Panels[1])
	
	game.ui.Options.NameField = gui.CreateTextfield(20, 50, 200, 20, game.ui.Options.Panels[1])
	game.ui.Options.NameField:SetText(config["name"])
	
	game.ui.Options.Spraylogo = gui.CreateImage(nil, 40, 100, 32, 32, game.ui.Options.Panels[1])
	game.ui.Options.SpraylogoLabel = gui.CreateLabel(language.get2("gui_options_player_spraylogo", {SPRAYLOGO = config["spraylogo"] or ""}), 20, 80, game.ui.Options.Panels[1])
	game.ui.Options.PrevSpraylogo = gui.CreateButton("<", 20, 110, 15, 15, game.ui.Options.Panels[1])
	game.ui.Options.NextSpraylogo = gui.CreateButton(">", 77, 110, 15, 15, game.ui.Options.Panels[1])
	
	function game.ui.Options.PrevSpraylogo:OnClick()
		if game.Spraylogo then
			game.SetSpraylogo(game.Spraylogo[1] - 1)
		end
	end
	
	function game.ui.Options.NextSpraylogo:OnClick()
		if game.Spraylogo then
			game.SetSpraylogo(game.Spraylogo[1] + 1)
		end
	end
	
	-- Controls panel
	game.ui.Options.Panels[2] = gui.CreatePanel(language.get("gui_options_tab_controls"), 10, 60, 650, 480, game.ui.Options.Window)
	game.ui.Options.MovementPanel = gui.CreatePanel(language.get("gui_options_controls_movement"), 10, 20, 120, 60, game.ui.Options.Panels[2])
	
	game.ui.Options.AbsMovementRadioButton = gui.CreateRadioButton(language.get("gui_options_controls_movement_absolute"), 10, 20, 5, game.ui.Options.MovementPanel)
	game.ui.Options.RelativeToDirRadioButton = gui.CreateRadioButton(language.get("gui_options_controls_movement_relativetodir"), 10, 40, 5, game.ui.Options.MovementPanel)
	
	if config["relativemovement"] == 0 then
		game.ui.Options.MovementPanel.RadioButton = game.ui.Options.AbsMovementRadioButton
	elseif config["relativemovement"] == 1 then
		game.ui.Options.MovementPanel.RadioButton = game.ui.Options.RelativeToDirRadioButton
	end
	
	game.ui.Options.ControlsList = gui.CreateListview(140, 20, 420, game.ui.Options.Panels[2])
	game.ui.Options.ControlsList:AddColumn(language.get("gui_options_controls_control"), 300)
	game.ui.Options.ControlsList:AddColumn(language.get("gui_options_controls_bind"), 200)
	game.Binds.Reload()
	
	function game.ui.Options.ControlsList:OnSelect(Index)
		local Items = game.ui.Options.ControlsList.Items[Index]
		if Items then
			game.ui.Options.ControlsField:SetText(Items[2])
		end
	end
	
	game.NewBinds = {}
	game.ui.Options.ControlsField = gui.CreateTextfield(140, 450, 200, 20, game.ui.Options.Panels[2])
	game.ui.Options.ControlsApplyButton = gui.CreateButton(language.get("gui_options_controls_apply"), 350, 450, 100, 20, game.ui.Options.Panels[2])
	function game.ui.Options.ControlsApplyButton:OnClick()
		local BindID = game.ui.Options.ControlsList.Selected
		local BindPack = game.Binds.List[BindID]
		if BindPack and BindPack[2] then
			game.NewBinds[BindPack[2]] = game.ui.Options.ControlsField:GetText()
			game.ui.Options.ControlsList:SetItem(BindID, game.Binds.List[BindID][1], game.ui.Options.ControlsField:GetText())
		end
	end
	
	-- Game panel
	game.ui.Options.Panels[3] = gui.CreatePanel(language.get("gui_options_tab_game"), 10, 60, 650, 480, game.ui.Options.Window)
	gui.CreateLabel(language.get("gui_options_game_language"), 20, 30, game.ui.Options.Panels[3])
	
	game.ui.LanguageBox = gui.CreateCombobox(20, 50, 200, 20, game.ui.Options.Panels[3])
	for Index, Item in pairs(language.list()) do
		game.ui.LanguageBox:SetItem(Index, Item)
		if config["cl_lang"] and config["cl_lang"] == Item then
			game.ui.LanguageBox:Select(Index)
		end
	end
	
	-- Graphics panel
	game.ui.Options.Panels[4] = gui.CreatePanel(language.get("gui_options_tab_graphics"), 10, 60, 650, 480, game.ui.Options.Window)
	
	-- Sound panel
	game.ui.Options.Panels[5] = gui.CreatePanel(language.get("gui_options_tab_sound"), 10, 60, 650, 480, game.ui.Options.Window)
	
	-- Net panel
	game.ui.Options.Panels[6] = gui.CreatePanel(language.get("gui_options_tab_net"), 10, 60, 650, 480, game.ui.Options.Window)
	
	-- More Panel
	game.ui.Options.Panels[7] = gui.CreatePanel(language.get("gui_options_tab_more"), 10, 60, 650, 480, game.ui.Options.Window)
	
	for i = 2, #game.ui.Options.Panels do
		game.ui.Options.Panels[i].Hidden = true
	end
	
	game.ReloadSpraylogos()
	InitializeOptionsMenu = nil
end

Hook.Add("load", InitializeOptionsMenu)