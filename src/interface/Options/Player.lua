local Path, PLAY2D, Interface, Options = ...
local Player = {}

function Player.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_player") )
	
	Options.Panel[1] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 60, Options.Window)
	
	Player.load = nil
	
end

return Player