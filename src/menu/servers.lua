function game.ui.OpenServerBrowser()
	game.ui.ServerBrowser.Hidden = nil
	game.ui.ServerBrowser:SetHoverAll()
end

local function InitializeServersMenu()
	game.ui.ServerBrowser = gui.CreateWindow(language.get("gui_label_find_servers"), 120, 10, 670, 580, game.ui.Desktop, true)
	game.ui.ServerBrowser.Hidden = true
	
	game.ui.ServerBrowserTab = gui.CreateTabber(10, 35, game.ui.ServerBrowser)
	game.ui.ServerBrowserTab:AddItem(language.get("gui_browser_tab_internet"))
	game.ui.ServerBrowserTab:AddItem(language.get("gui_browser_tab_official"))
	game.ui.ServerBrowserTab:AddItem(language.get("gui_browser_tab_lan"))
	game.ui.ServerBrowserTab:AddItem(language.get("gui_browser_tab_favorites"))
	game.ui.ServerBrowserTab:AddItem(language.get("gui_browser_tab_history"))
	game.ui.ServerBrowserTab.Selected = 1
	
	game.ui.ServerBrowserList = gui.CreateListview(10, 60, 480, game.ui.ServerBrowser)
	game.ui.ServerBrowserList:AddColumn(language.get("gui_browser_password"), 30)
	game.ui.ServerBrowserList:AddColumn(language.get("gui_browser_servername"), 200)
	game.ui.ServerBrowserList:AddColumn(language.get("gui_browser_gamemode"), 200)
	game.ui.ServerBrowserList:AddColumn(language.get("gui_browser_map"), 120)
	game.ui.ServerBrowserList:AddColumn(language.get("gui_browser_players"), 50)
	game.ui.ServerBrowserList:AddColumn(language.get("gui_browser_ping"), 50)
	
	game.ui.ServerBrowserFiltersButton = gui.CreateButton(language.get("gui_browser_filter"), 10, 550, 100, 20, game.ui.ServerBrowser)
	
	game.ui.ServerBrowserRefreshButton = gui.CreateButton(language.get("gui_browser_refresh"), 120, 550, 100, 20, game.ui.ServerBrowser)
	
	game.ui.ServerBrowserConnectButton = gui.CreateButton(language.get("gui_browser_connect"), 555, 550, 100, 20, game.ui.ServerBrowser)
	InitializeServersMenu = nil
end

Hook.Add("load", InitializeServersMenu)