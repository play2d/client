local Path, PLAY2D, Interface, Options = ...
local Controls = {}

function Controls.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_controls") )
	
	Options.Panel[2] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	Controls.load = nil
	
end

return Controls