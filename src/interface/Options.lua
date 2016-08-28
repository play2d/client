local Path, PLAY2D, Interface = ...
local Options = {}

function Options.load()
	Options.Label = Interface.Desktop.CreateLabel(Interface.Language.Translation["label_options"], 30, 250)
	
	Options.load = nil
end

return Options