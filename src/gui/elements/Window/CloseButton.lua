local gui = ...
local Element = gui.register("WindowCloseButton", "Button")

Element.CloseImage = love.graphics.newImage(gui.Path.."/images/Delete-16.png")

Element.Color = {255, 80, 80, 255}
Element.ColorHover = {255, 120, 120, 255}
Element.ColorPressed = {200, 50, 50, 255}

Element.Rounded = true
Element.ArcRadius = 4

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	self.Layout.Image = Element.CloseImage
	
	self.Layout.Color = Element.Color
	self.Layout.ColorHover = Element.ColorHover
	self.Layout.ColorPressed = Element.ColorPressed
	
	self.Layout.Rounded = Element.Rounded
	self.Layout.ArcRadius = Element.ArcRadius
	
end

function Element:MouseReleased(...)
	
	Element.Base.MouseReleased(self, ...)
	
	local Parent = self.Parent
	
	if Parent.Closeable and self.IsHover then
		
		Parent.Hidden = true
		
	end
	
end