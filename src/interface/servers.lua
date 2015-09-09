Interface.Servers = {}

function Interface.Servers.Open()
	Interface.Servers.Window.Hidden = nil
	Interface.Servers.Window:Focus()
end

function Interface.Servers.Initialize()
	Interface.Servers.Window = gui.CreateWindow(Lang.Get("gui_label_find_servers"), 120, 10, 670, 580, Interface.Desktop, true)
	Interface.Servers.Window.Hidden = true
	
	Interface.Servers.Tab = gui.CreateTabber(10, 35, Interface.Servers.Window)
	Interface.Servers.Tab:AddItem(Lang.Get("gui_browser_tab_internet"))
	Interface.Servers.Tab:AddItem(Lang.Get("gui_browser_tab_official"))
	Interface.Servers.Tab:AddItem(Lang.Get("gui_browser_tab_lan"))
	Interface.Servers.Tab:AddItem(Lang.Get("gui_browser_tab_favorites"))
	Interface.Servers.Tab:AddItem(Lang.Get("gui_browser_tab_history"))
	Interface.Servers.Tab.Selected = 1
	
	Interface.Servers.List = gui.CreateListview(10, 60, 480, Interface.Servers.Window)
	Interface.Servers.List:AddColumn(Lang.Get("gui_browser_password"), 30)
	Interface.Servers.List:AddColumn(Lang.Get("gui_browser_servername"), 200)
	Interface.Servers.List:AddColumn(Lang.Get("gui_browser_gamemode"), 200)
	Interface.Servers.List:AddColumn(Lang.Get("gui_browser_map"), 120)
	Interface.Servers.List:AddColumn(Lang.Get("gui_browser_players"), 50)
	Interface.Servers.List:AddColumn(Lang.Get("gui_browser_ping"), 50)
	
	Interface.Servers.FiltersButton = gui.CreateButton(Lang.Get("gui_browser_filter"), 10, 550, 100, 20, Interface.Servers.Window)
	
	Interface.Servers.RefreshButton = gui.CreateButton(Lang.Get("gui_browser_refresh"), 120, 550, 100, 20, Interface.Servers.Window)
	
	Interface.Servers.ConnectButton = gui.CreateButton(Lang.Get("gui_browser_connect"), 555, 550, 100, 20, Interface.Servers.Window)
	Interface.Servers.Initialize = nil
end