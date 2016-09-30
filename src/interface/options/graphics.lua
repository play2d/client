local Path, PLAY2D, Interface, Options = ...
local gui = PLAY2D.gui

local Graphics = {}

function Graphics.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_graphics") )
	
	Options.Panel[4] = gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	Graphics.load = nil
	
end

function Graphics.Okay()
	
end

function Graphics.Cancel()
	
end

return Graphics