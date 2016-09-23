local Path, PLAY2D, Interface = ...
local Desktop = {}

local LabelFont = love.graphics.newFont(PLAY2D.gui.Fonts["Kanit Light"], 16)

local function LabelEnterColor(self)
	
	self.Layout.TextColor = {255, 255, 255, 255}
	self.Changed = true
	
end

local function LabelExitColor(self)
	
	self.Layout.TextColor = {150, 150, 150, 255}
	self.Changed = true
	
end

function Desktop.CreateLabel(Text, x, y)
	
	local Label = PLAY2D.gui.create("Label", Text, x, y, 120, 25, PLAY2D.Main)
	
	Label.Layout.TextColor = {150, 150, 150, 255}
	Label.Layout.TextFont = LabelFont
	Label.OnMouseEnter = LabelEnterColor
	Label.OnMouseExit = LabelExitColor
	
	return Label
	
end

function Desktop.load()
	
	local Width, Height = PLAY2D.gui.Desktop:GetDimensions()
	
	PLAY2D.Main = PLAY2D.gui.create("Panel", 0, 0, Width, Height, PLAY2D.gui.Desktop)
	PLAY2D.Main:SetSplash(love.graphics.newImage("assets/gfx/splash.png"))
	
	Desktop.load = nil
	
end

return Desktop