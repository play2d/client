local Path, PLAY2D, Interface = ...
local Servers = {}

function Servers.load()
	
	Servers.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_servers"), 30, 300)
	
	function Servers.Label:OnMouseReleased()
		
		if self.IsHover then
			
			Servers.Window.Hidden = false
			Servers.Window:SetHover()
			
		end
		
	end
	
	Servers.Window = PLAY2D.gui.create("Window", Interface.Language:Get("label_servers"), 140, 20, 640, 560, PLAY2D.Main)
	Servers.Window.Hidden = true
	
	Servers.List = PLAY2D.gui.create("ListView", 10, 60, Servers.Window:GetWidth() - 20, Servers.Window:GetHeight() - 100, Servers.Window)
	
	Servers.Table = {
		
		Pass = Servers.List:CreateColumn(Interface.Language:Get("servers_password"), 40),
		Name = Servers.List:CreateColumn(Interface.Language:Get("servers_name"), 200),
		Mode = Servers.List:CreateColumn(Interface.Language:Get("servers_gamemode"), 120),
		Map = Servers.List:CreateColumn(Interface.Language:Get("servers_map"), 150),
		Players = Servers.List:CreateColumn(Interface.Language:Get("servers_players"), 60),
		Ping = Servers.List:CreateColumn(Interface.Language:Get("servers_ping"), 50)
		
	}
	
	Servers.load = nil
	
end

return Servers