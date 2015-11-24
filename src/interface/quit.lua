Interface.Quit = {}

function Interface.Quit.Open()
	Interface.Quit.Window.Hidden = false
	Interface.Quit.Window:Focus()
end

function Interface.Quit.Initialize()
	Interface.Quit.Window = gui.CreateWindow(Lang.Get("gui_label_quit"), Interface.Desktop:GetWidth()/2 - 150, Interface.Desktop:GetHeight()/2 - 50, 300, 100, Interface.MainMenu)
	Interface.Quit.Window.Hidden = true
	
	Interface.Quit.Label = gui.CreateLabel(Lang.Get("gui_quit_message"), 15, 35, Interface.Quit.Window)
	
	Interface.Quit.Yes = gui.CreateButton(Lang.Get("gui_quit_yes"), 40, 60, 100, 20, Interface.Quit.Window)
	Interface.Quit.Yes.OnDrop = love.event.quit
	
	Interface.Quit.No = gui.CreateButton(Lang.Get("gui_quit_no"), 160, 60, 100, 20, Interface.Quit.Window)
	function Interface.Quit.No:OnDrop()
		Interface.Quit.Window.Hidden = true
	end
	
	Interface.Quit.Initialize = nil
end

Hook.Create("quit")
function love.quit()
	if Interface.Quit.Yes.Grabbed ~= nil then
		Hook.Call("quit")
		return true
	end
end