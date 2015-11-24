Interface.Servers = {
	ServerList = {},
	Request = {}
}

function Interface.Servers.Open()
	Interface.Servers.Window.Hidden = nil
	Interface.Servers.Window:Focus()
end

function Interface.Servers.AddServer(ServerData)
	if type(ServerData) == "table" then
		for _, Server in pairs(Interface.Servers.ServerList) do
			if Server.Address == ServerData.Address then
				return nil
			end
		end
		table.insert(Interface.Servers.ServerList, ServerData)
		Interface.Servers.UpdateList()
	end
end

function Interface.Servers.UpdateList()
	table.sort(Interface.Servers.ServerList,
		function (ServerA, ServerB)
			return ServerA.Ping < ServerB.Ping
		end
	)
	
	Interface.Servers.List:ClearItems()
	for _, Server in pairs(Interface.Servers.ServerList) do
		Interface.Servers.List:AddItem(Server.Password and "Yes" or "No", Server.Name, Server.Mode, Server.Map, Server.Players.."/"..Server.MaxPlayers, Server.Ping)
	end
end

function Interface.Servers.Refresh()
	for _, Address in pairs(Cache.List) do
		Peer = Core.Network.Host:connect(Address, CONST.NET.CHANNELS.MAX)
		Interface.Servers.Request[Address] = true
	end
	
	Interface.Servers.ServerList = {}
	Interface.Servers.List:ClearItems()
end

function Interface.Servers.Initialize()
	Interface.Servers.Window = gui.CreateWindow(Lang.Get("gui_label_find_servers"), 120, 10, 670, 580, Interface.MainMenu, true)
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
	Interface.Servers.RefreshButton.OnClick = Interface.Servers.Refresh
	
	Interface.Servers.ConnectButton = gui.CreateButton(Lang.Get("gui_browser_connect"), 555, 550, 100, 20, Interface.Servers.Window)
	Interface.Servers.ConnectButton.OnClick = Interface.Connecting.Connect
	Interface.Servers.Initialize = nil
end

Hook.Add("ENetConnect",
	function (Peer)
		local Address = tostring(Peer)
		if Interface.Servers.Request[Address] then
			Interface.Servers.Request[Address] = nil
			
			local Request = ("")
				:WriteShort(CONST.NET.SERVERINFO)
			
			Peer:send(Request, CONST.NET.CHANNELS.UNCONNECTED, "reliable")
		end
	end
)

Hook.Add("ENetDisconnect",
	function (Peer)
		Interface.Servers.Request[tostring(Peer)] = nil
	end
)