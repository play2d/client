local Path, PLAY2D, Interface, Options = ...
local Sound = {}

function Sound.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_sound") )
	
	Options.Panel[5] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 60, Options.Window)
	
	Sound.load = nil
	
end

return Sound