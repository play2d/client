local Path, PLAY2D, Interface, Options = ...
local More = {}

function More.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_more") )
	
	Options.Panel[7] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 60, Options.Window)
	
	More.load = nil
	
end

return More