local Path, PLAY2D, Interface = ...
local Chat = {}

function Chat.load()
	
	Chat.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_chat"), 30, 360)
	
	Chat.load = nil
	
end

return Chat