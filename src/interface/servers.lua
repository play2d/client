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
	
	Servers.Window = PLAY2D.gui.create("Window", Interface.Language:Get("label_servers"), 200, 20, 580, 560, PLAY2D.Main)
	Servers.Window.Hidden = true
	
	Servers.List = PLAY2D.gui.create("ListView", 10, 60, Servers.Window:GetWidth() - 20, Servers.Window:GetHeight() - 70, Servers.Window)
	local c1 = Servers.List:CreateColumn("Test", 200)
	local c2 =Servers.List:CreateColumn("Another", 300)
	
	for i = 1, 200 do
		Servers.List:AddItem(c1, "Item: "..i)
		Servers.List:AddItem(c2, "Another "..i)
	end
	
	Servers.load = nil
	
end

return Servers