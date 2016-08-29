local gui = ...
local Element = gui.register("Element", "Base")

function Element:Init()
	self.Layout = {}
	
	local Skin = self:GetSkin()
	if Skin.Init then
		Skin.Init(self)
	end
	
	local Width, Height = self:GetDimensions()
	if Width and Height and Width > 0 and Height > 0 then
		self.Canvas = love.graphics.newCanvas(Width, Height)
	end
	
	self.Changed = true
end

function Element:FindMouseHoverChild(x, y)
	if not self.Hidden then
		local Horizontal, Vertical = self:GetPosition()
		local x, y = x - Horizontal, y - Vertical
		if self:LocalPointInArea(x, y) then
			return self
		end
	end
end

function Element:FindTopElement()
	if not self.Hidden then
		return self
	end
end