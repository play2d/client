local Path, PLAY2D, Interface, Options = ...
local gui = PLAY2D.gui

local Sound = {}

function Sound.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_sound") )
	
	Options.Panel[5] = gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	Sound.load = nil
	
end

function Sound.Okay()
	
end

function Sound.Cancel()
	
end

return Sound