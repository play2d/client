local Path, gui = ...
local MenuSpacer = {}

MenuSpacer.Color = {150, 150, 150, 255}

function MenuSpacer:Init()
	self.Layout.Color = MenuSpacer.Color
	self.Height = 5
end

function MenuSpacer:Paint(x, y)
	local Width, Height = self:GetDimensions()
	
	love.graphics.setColor(self.Layout.Color)
	love.graphics.line(x, y + Height/2, x + Width, y + Height/2)
end

return MenuSpacer