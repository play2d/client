local Path, PLAY2D, Interface = ...
local Options = {}

function Options.load()
	Options.Label = Interface.Desktop.CreateLabel(Interface.Language.Translation["label_options"], 30, 350)
	
	function Options.Label:OnMouseReleased()
		if self.IsHover then
			Options.Window.Hidden = false
		end
	end
	
	Options.Window = PLAY2D.gui.create("Window", Interface.Language.Translation["label_options"], 300, 20, 480, 560, PLAY2D.Main)
	Options.Window.Hidden = true
	
	Options.load = nil
end

return Options