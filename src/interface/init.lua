local Path, PLAY2D = ...
local Interface = {}

Interface.Desktop = PLAY2D.Require(Path.."/Desktop", Interface)

function Interface.load()
	
	Interface.Desktop.load()
	
	Interface.load = nil
end

return Interface