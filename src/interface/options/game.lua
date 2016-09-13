local Path, PLAY2D, Interface, Options = ...
local Game = {}

function Game.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_game") )
	
	Options.Panel[3] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	Game.GoreLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_game_gore"), 10, 50, 100, 20, Options.Panel[3])
	
	Game.RadarLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_game_radar"), 10, 80, 100, 20, Options.Panel[3])
	
	Game.LanguageLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_game_language"), 10, 110, 100, 20, Options.Panel[3])
	
	Game.LanguageBox = PLAY2D.gui.create("ComboBox", 110, 110, 200, 20, Options.Panel[3])
	
	Game.load = nil
	
end

return Game