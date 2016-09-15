local Path, PLAY2D, Interface, Options = ...
local Game = {}

function Game.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_game") )
	
	Options.Panel[3] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	-- Gore
	
	Game.GoreLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_game_gore"), 10, 50, 100, 20, Options.Panel[3])
	
	Game.GoreSlider = PLAY2D.gui.create("HSlider", 110, 50, 200, 50, Options.Panel[3])
	
	-- Radar
	
	Game.RadarLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_game_radar"), 10, 80, 100, 20, Options.Panel[3])
	
	-- Language
	
	Game.LanguageLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_game_language"), 10, 110, 100, 20, Options.Panel[3])
	
	Game.LanguageBox = PLAY2D.gui.create("ComboBox", 110, 110, 200, 20, Options.Panel[3])
	
	for Name, Language in pairs(PLAY2D.Language.List) do
		
		Game.LanguageBox:AddItem(Name)
		
	end
	
	Game.load = nil
	
end

return Game