local Path, PLAY2D, Interface = ...
local Options = {}

Options.Player = PLAY2D.Require("interface/options/player", Interface, Options)

function Options.load()
	
	Options.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_options"), 30, 350)
	
	function Options.Label:OnMouseReleased()
		
		if self.IsHover then
			
			Options.Window.Hidden = false
			
		end
		
	end
	
	Options.Window = PLAY2D.gui.create("Window", Interface.Language:Get("label_options"), 300, 20, 480, 560, PLAY2D.Main)
	Options.Window.Hidden = true
	
	Options.Tab = PLAY2D.gui.create("Tabber", 10, 30, Options.Window:GetWidth() - 20, 20, Options.Window)
	
	Options.Player.load()
	
	Options.Tab:Select(1)
	
	Options.load = nil
	
end

return Options