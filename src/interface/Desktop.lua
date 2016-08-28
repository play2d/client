local Path, PLAY2D, Interface = ...
local Desktop = {}

function Desktop.load()
	local Width, Height = PLAY2D.gui.Desktop:GetDimensions()
	
	PLAY2D.Main = PLAY2D.gui.create("Panel", 0, 0, Width, Height, PLAY2D.gui.Desktop)
	PLAY2D.Main:SetSplash(love.graphics.newImage("gfx/splash.png"))
	
	Desktop.load = nil
end

return Desktop