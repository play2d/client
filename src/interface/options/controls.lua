local Path, PLAY2D, Interface, Options = ...
local gui = PLAY2D.gui

local Controls = {}

function Controls.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_controls") )
	
	Options.Panel[2] = gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	Controls.load = nil
	
end

function Controls.Okay()
	
end

function Controls.Cancel()
	
end

return Controls