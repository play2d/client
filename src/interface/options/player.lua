local Path, PLAY2D, Interface, Options = ...
local Player = {}

function Player.load()
	
	-- Commands used
	
	Player.Command = {
		
		Name = PLAY2D.Commands.List["name"]
		
	}
	
	Options.Tab:AddItem( Interface.Language:Get("options_player") )
	
	Options.Panel[1] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	-- Name
	Player.NameLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_player_name"), 10, 20, 150, 20, Options.Panel[1])
	Player.NameField = PLAY2D.gui.create("TextField", 150, 20, 300, 20, Options.Panel[1])
	
	Player.SpraylogoLabel = PLAY2D.gui.create("Label", Interface.Language:Get("options_player_spraylogo"), 10, 60, 150, 20, Options.Panel[1])
	
	-- Setup
	Player.NameField:SetText(Player.Command.Name:GetString())
	
	Player.load = nil
	
end

function Player.Okay()
	
	Player.Command.Name:Set(Player.NameField:GetText())
	
end

function Player.Cancel()
	
	Player.NameField:SetText(Player.Command.Name:GetString())
	
end

return Player