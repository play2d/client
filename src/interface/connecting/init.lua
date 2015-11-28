Interface.Connecting = {}

function Interface.Connecting.Initialize()
	Interface.Connecting.Menu = gui.CreateCanvas(0, 0, Interface.Desktop:GetWidth(), Interface.Desktop:GetHeight(), Interface.Desktop)
	Interface.Connecting.Menu:Hide()
	
	Interface.Connecting.Window = gui.CreateWindow(Lang.Get("gui_connecting_window"), Interface.Connecting.Menu:GetWidth()/2 - 200, Interface.Connecting.Menu:GetHeight()/2 - 100, 400, 200, Interface.Connecting.Menu)
	
	Interface.Connecting.Label = gui.CreateLabel(Lang.Get("gui_connecting_opening"), 10, 40, Interface.Connecting.Window)
	
	Interface.Connecting.State = gui.CreateLabel(Lang.Get("gui_connecting_state"), 10, 40, Interface.Connecting.Window)
	
	Interface.Connecting.Transfer = {}
	Interface.Connecting.Transfer.Panel = gui.CreatePanel(Lang.Get("gui_connecting_files"), 10, 40, 380, 140, Interface.Connecting.Window)
	Interface.Connecting.Transfer.Label = gui.CreateLabel(Lang.Get("gui_connecting_file"), 10, 30, Interface.Connecting.Transfer.Panel)
	
	Interface.Connecting.ErrorWindow = gui.CreateWindow(Lang.Get("gui_connecting_error"), Interface.MainMenu:GetWidth()/2 - 200, Interface.MainMenu:GetHeight()/2 - 100, 400, 200, Interface.MainMenu)
	
	Interface.Connecting.Password = {}
	Interface.Connecting.Password.Panel = gui.CreatePanel(Lang.Get("gui_connecting_password"), 10, 40, 380, 140, Interface.Connecting.ErrorWindow)
	Interface.Connecting.Password.Field = gui.CreateTextfield(10, 30, 200, 20, Interface.Connecting.Password.Panel)
	Interface.Connecting.Password.Field.Password = true
	Interface.Connecting.Password.Connect = gui.CreateButton(Lang.Get("gui_browser_connect"), 270, 110, 100, 20, Interface.Connecting.Password.Panel)
	
	Interface.Connecting.ErrorWindow:Hide()
	Interface.Connecting.Label:Hide()
	Interface.Connecting.State:Hide()
	Interface.Connecting.Transfer.Panel:Hide()
	Interface.Connecting.Password.Panel:Hide()
	
	function Interface.Connecting.Password.Connect:OnClick()
		Interface.Connecting.ConnectTo(tostring(Core.Connect.Request))
	end
end

function Interface.Connecting.ConnectTo(Address)
	Interface.MainMenu:Hide()
	
	Interface.Connecting.Menu:Show()
	Interface.Connecting.Window:Show()
	Interface.Connecting.Window:Focus()
	Interface.Connecting.Label:Show()
	
	Interface.Connecting.ErrorWindow:Hide()
	Interface.Connecting.Label:Show()
	Interface.Connecting.State:Hide()
	Interface.Connecting.Transfer.Panel:Hide()
	Interface.Connecting.Password.Panel:Hide()
	
	Core.Connect.ConnectTo(Address)
end

function Interface.Connecting.Connect()
	local Selected = Interface.Servers.ServerList[Interface.Servers.List.Selected]
	if Selected then
		Interface.Connecting.ConnectTo(Selected.Address)
	end
end

function Interface.Connecting.Cancel()
	Interface.MainMenu:Show()
	Interface.Connecting.Menu:Hide()
	
	Interface.Connecting.ErrorWindow:Hide()
	Interface.Connecting.Label:Hide()
	Interface.Connecting.State:Hide()
	Interface.Connecting.Transfer.Panel:Hide()
	Interface.Connecting.Password.Panel:Hide()
end