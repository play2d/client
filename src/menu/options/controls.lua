Options.Controls = {}

function Options.Controls.Okay()
	-- Relative to dir movement
	if Options.Controls.MovementPanel.RadioButton == Options.Controls.AbsMovementRadioButton then
		Config.CFG["relativemovement"] = 0
	elseif Options.Controls.MovementPanel.RadioButton == Options.Controls.RelativeToDirRadioButton then
		Config.CFG["relativemovement"] = 1
	end

	-- Apply new binds
	for Bind, Key in pairs(Options.Controls.NewBinds) do
		local PreviousBind = Binds.Find(Bind)
		if PreviousBind then
			Config.CFG["bind"][PreviousBind] = nil
		end
		Config.CFG["bind"][Key] = Bind
	end
	Options.Controls.NewBinds = {}
end

function Options.Controls.Cancel()
	-- Relative to dir movement
	if Config.CFG["relativemovement"] == 0 then
		Options.Controls.MovementPanel.RadioButton = Options.Controls.AbsMovementRadioButton
	elseif Config.CFG["relativemovement"] == 1 then
		Options.Controls.MovementPanel.RadioButton = Options.Controls.RelativeToDirRadioButton
	end

	-- Delete the new binds and reload the listview with the current binds
	Options.Controls.NewBinds = {}
	Binds.Reload()
end

function Options.Controls.InitializeMenu()
	Options.Panels[2] = gui.CreatePanel(Lang.Get("gui_options_tab_controls"), 10, 60, 650, 480, Options.Window)
	Options.Controls.MovementPanel = gui.CreatePanel(Lang.Get("gui_options_controls_movement"), 10, 20, 120, 60, Options.Panels[2])
	
	Options.Controls.AbsMovementRadioButton = gui.CreateRadioButton(Lang.Get("gui_options_controls_movement_absolute"), 10, 20, 5, Options.Controls.MovementPanel)
	Options.Controls.RelativeToDirRadioButton = gui.CreateRadioButton(Lang.Get("gui_options_controls_movement_relativetodir"), 10, 40, 5, Options.Controls.MovementPanel)
	
	if Config.CFG["relativemovement"] == 0 then
		Options.Controls.MovementPanel.RadioButton = Options.Controls.AbsMovementRadioButton
	elseif Config.CFG["relativemovement"] == 1 then
		Options.Controls.MovementPanel.RadioButton = Options.Controls.RelativeToDirRadioButton
	end
	
	Options.Controls.List = gui.CreateListview(140, 20, 420, Options.Panels[2])
	Options.Controls.List:AddColumn(Lang.Get("gui_options_controls_control"), 300)
	Options.Controls.List:AddColumn(Lang.Get("gui_options_controls_bind"), 200)
	Binds.Reload()
	
	function Options.Controls.List:OnSelect(Index)
		local Items = Options.Controls.List.Items[Index]
		if Items then
			Options.Controls.Field:SetText(Items[2])
		end
	end
	
	Options.Controls.NewBinds = {}
	Options.Controls.Field = gui.CreateTextfield(140, 450, 200, 20, Options.Panels[2])
	Options.Controls.ApplyButton = gui.CreateButton(Lang.Get("gui_options_controls_apply"), 350, 450, 100, 20, Options.Panels[2])
	
	function Options.Controls.ApplyButton:OnClick()
		local BindID = Options.Controls.List.Selected
		local BindPack = Binds.List[BindID]
		if BindPack and BindPack[2] then
			Options.Controls.NewBinds[BindPack[2]] = Options.Controls.Field:GetText()
			Options.Controls.List:SetItem(BindID, Binds.List[BindID][1], Options.Controls.Field:GetText())
		end
	end
	
	Options.Controls.InitializeMenu = nil
end