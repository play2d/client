Interface.Servers = {}

function Interface.Servers.Open()
	Interface.ServerBrowser.Hidden = nil
	Interface.ServerBrowser:SetHoverAll()
end

function Interface.Servers.Initialize()
	Interface.ServerBrowser = gui.CreateWindow(Lang.Get("gui_label_find_servers"), 120, 10, 670, 580, Interface.Desktop, true)
	Interface.ServerBrowser.Hidden = true
	
	Interface.ServerBrowserTab = gui.CreateTabber(10, 35, Interface.ServerBrowser)
	Interface.ServerBrowserTab:AddItem(Lang.Get("gui_browser_tab_internet"))
	Interface.ServerBrowserTab:AddItem(Lang.Get("gui_browser_tab_official"))
	Interface.ServerBrowserTab:AddItem(Lang.Get("gui_browser_tab_lan"))
	Interface.ServerBrowserTab:AddItem(Lang.Get("gui_browser_tab_favorites"))
	Interface.ServerBrowserTab:AddItem(Lang.Get("gui_browser_tab_history"))
	Interface.ServerBrowserTab.Selected = 1
	
	Interface.ServerBrowserList = gui.CreateListview(10, 60, 480, Interface.ServerBrowser)
	Interface.ServerBrowserList:AddColumn(Lang.Get("gui_browser_password"), 30)
	Interface.ServerBrowserList:AddColumn(Lang.Get("gui_browser_servername"), 200)
	Interface.ServerBrowserList:AddColumn(Lang.Get("gui_browser_gamemode"), 200)
	Interface.ServerBrowserList:AddColumn(Lang.Get("gui_browser_map"), 120)
	Interface.ServerBrowserList:AddColumn(Lang.Get("gui_browser_players"), 50)
	Interface.ServerBrowserList:AddColumn(Lang.Get("gui_browser_ping"), 50)
	
	Interface.ServerBrowserFiltersButton = gui.CreateButton(Lang.Get("gui_browser_filter"), 10, 550, 100, 20, Interface.ServerBrowser)
	
	Interface.ServerBrowserRefreshButton = gui.CreateButton(Lang.Get("gui_browser_refresh"), 120, 550, 100, 20, Interface.ServerBrowser)
	
	Interface.ServerBrowserConnectButton = gui.CreateButton(Lang.Get("gui_browser_connect"), 555, 550, 100, 20, Interface.ServerBrowser)
	Interface.Servers.Initialize = nil
end