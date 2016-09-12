local Path, PLAY2D, Interface, Options = ...
local Game = {}

function Game.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_game") )
	
	Options.Panel[3] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 60, Options.Window)
	
	Game.load = nil
	
end

return Game