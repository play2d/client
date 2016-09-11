local Path, PLAY2D, Interface, Options = ...
local Player = {}

function Player.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_player") )
	
	Player.load = nil
	
end

return Player