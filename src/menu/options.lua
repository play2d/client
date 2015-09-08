local Path = ...

Options = {}

require(Path..".player")
require(Path..".controls")
require(Path..".game")
require(Path..".graphics")
require(Path..".sound")
require(Path..".net")
require(Path..".more")

function Options.Open()
	Options.Window.Hidden = nil
end

function Interface.InitializeOptionsMenu()
	Options.Window = gui.CreateWindow(Lang.Get("gui_label_options"), 120, 10, 670, 580, Interface.Desktop)
	Options.Window.Hidden = true
	
	Options.Tab = gui.CreateTabber(10, 35, Options.Window)
	Options.Tab:AddItem(Lang.Get("gui_options_tab_player"))
	Options.Tab:AddItem(Lang.Get("gui_options_tab_controls"))
	Options.Tab:AddItem(Lang.Get("gui_options_tab_game"))
	Options.Tab:AddItem(Lang.Get("gui_options_tab_graphics"))
	Options.Tab:AddItem(Lang.Get("gui_options_tab_sound"))
	Options.Tab:AddItem(Lang.Get("gui_options_tab_net"))
	Options.Tab:AddItem(Lang.Get("gui_options_tab_more"))
	
	Options.Okay = gui.CreateButton(Lang.Get("gui_label_okay"), 450, 550, 100, 20, Options.Window)
	function Options.Okay:OnClick()
		Options.Player.Okay()
		Options.Controls.Okay()
		Options.Game.Okay()
		
		Options.Window.Hidden = true
		
		-- Save the Config.CFGuration
		Config.Save()
	end
	
	Options.Cancel = gui.CreateButton(Lang.Get("gui_label_cancel"), 560, 550, 100, 20, Options.Window)
	function Options.Cancel:OnClick()
		Options.Player.Cancel()
		Options.Controls.Cancel()
		Options.Game.Cancel()
		
		Options.Window.Hidden = true
	end
	
	function Options.Tab:OnSelect(Index)
		Options.Panels[self.Selected].Hidden = true
		Options.Panels[Index].Hidden = nil
	end
	
	Options.Panels = {}
	Options.Player.InitializeMenu()
	Options.Controls.InitializeMenu()
	Options.Game.InitializeMenu()
	
	-- Graphics panel
	Options.Panels[4] = gui.CreatePanel(Lang.Get("gui_options_tab_graphics"), 10, 60, 650, 480, Options.Window)
	
	-- Sound panel
	Options.Panels[5] = gui.CreatePanel(Lang.Get("gui_options_tab_sound"), 10, 60, 650, 480, Options.Window)
	
	-- Net panel
	Options.Panels[6] = gui.CreatePanel(Lang.Get("gui_options_tab_net"), 10, 60, 650, 480, Options.Window)
	
	-- More Panel
	Options.Panels[7] = gui.CreatePanel(Lang.Get("gui_options_tab_more"), 10, 60, 650, 480, Options.Window)
	
	for i = 2, #Options.Panels do
		Options.Panels[i].Hidden = true
	end

	Options.InitializeMenu = nil
end