local Path, PLAY2D, Interface, Options = ...
local gui = PLAY2D.gui

local More = {}

function More.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_more") )
	
	Options.Panel[7] = gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	More.load = nil
	
end

function More.Okay()
	
end

function More.Cancel()
	
end

return More