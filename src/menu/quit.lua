Interface.Quit = {}

function Interface.Quit.Open()
	Interface.Quit.Window.Hidden = false
end

function Interface.InitializeQuitMenu()
	Interface.Quit.Window = gui.CreateWindow(Lang.Get("gui_label_quit"), Interface.Desktop:GetWidth()/2 - 150, Interface.Desktop:GetHeight()/2 - 50, 300, 100, Interface.Desktop)
	Interface.Quit.Window.Hidden = true
	
	Interface.Quit.Label = gui.CreateLabel(Lang.Get("gui_quit_message"), 15, 35, Interface.Quit.Window)
	
	Interface.Quit.Yes = gui.CreateButton(Lang.Get("gui_quit_yes"), 40, 60, 100, 20, Interface.Quit.Window)
	Interface.Quit.Yes.OnClick = love.event.quit
	
	Interface.Quit.No = gui.CreateButton(Lang.Get("gui_quit_no"), 160, 60, 100, 20, Interface.Quit.Window)
	function Interface.Quit.No:OnClick()
		Interface.Quit.Window.Hidden = true
	end
	
	Interface.InitializeQuitMenu = nil
end

function love.quit()
	return Interface.Quit.Yes.Grabbed == nil
end