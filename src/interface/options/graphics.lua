local Path, PLAY2D, Interface, Options = ...
local Graphics = {}

function Graphics.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_graphics") )
	
	Options.Panel[4] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 60, Options.Window)
	
	Graphics.load = nil
	
end

return Graphics