local Path, PLAY2D, Interface, Options = ...
local Net = {}

function Net.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_net") )
	
	Options.Panel[6] = PLAY2D.gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	Net.load = nil
	
end

function Net.Okay()
	
end

function Net.Cancel()
	
end

return Net