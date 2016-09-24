local Path, PLAY2D, Interface = ...
local Help = {}

function Help.load()
	
	Help.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_help"), 30, 420)
	
	Help.load = nil
	
end

return Help