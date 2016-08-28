local Path, PLAY2D, Interface = ...
local Desktop = {}

function Desktop.load()
	PLAY2D.gui.Desktop:SetSplash(love.graphics.newImage("gfx/splash.png"))
	
	Desktop.load = nil
end

return Desktop