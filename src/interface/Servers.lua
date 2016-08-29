local Path, PLAY2D, Interface = ...
local Servers = {}

function Servers.load()
	Servers.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_servers"), 30, 300)
	
	function Servers.Label:OnMouseReleased()
		if self.IsHover then
			Servers.Window.Hidden = false
		end
	end
	
	Servers.Window = PLAY2D.gui.create("Window", Interface.Language:Get("label_servers"), 200, 20, 580, 560, PLAY2D.Main)
	Servers.Window.Hidden = true
	
	Servers.load = nil
end

return Servers