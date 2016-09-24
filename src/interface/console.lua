local Path, PLAY2D, Interface = ...
local Console = {}

function Console.load()
	
	Console.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_console"), 30, 250)
	
	Console.load = nil
	
end

return Console