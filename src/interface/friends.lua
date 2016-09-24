local Path, PLAY2D, Interface = ...
local Friends = {}

function Friends.load()
	
	Friends.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_friends"), 30, 340)
	
	Friends.load = nil
	
end

return Friends