local Path, PLAY2D, Interface, Options = ...
local Player = {}

function Player.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_player") )
	
	Options.Panel[1] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	Player.NameLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_player_name"), 10, 20, 150, 20, Options.Panel[1])
	Player.NameField = PLAY2D.gui.create("TextField", 150, 20, 300, 20, Options.Panel[1])
	
	Player.SpraylogoLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_player_spraylogo"), 10, 60, 150, 20, Options.Panel[1])
	
	Player.load = nil
	
end

function Player.Okay()
	
end

function Player.Cancel()
	
end

return Player