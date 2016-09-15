local gui = ...
local Element = gui.register("Button", "Element")

Element.Gradient = love.graphics.newMesh(
	{
		{
			0, 0,
			0, 0,
			255, 255, 255
		},
		{
			1, 0,
			1, 0,
			255, 255, 255
		},
		{
			1, 1,
			1, 1,
			208.63636363636, 208.63636363636, 208.63636363636
		},
		{
			0, 1,
			0, 1,
			208.63636363636, 208.63636363636, 208.63636363636
		}
	}
, "fan", "static")

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}

Element.Color = {255, 255, 255, 255}
Element.ColorHover = {240, 240, 240, 255}
Element.ColorPressed = {220, 220, 220, 255}
Element.BorderColor = {100, 100, 100, 255}
Element.ImageColor = {255, 255, 255, 255}
Element.Rounded = false
Element.ArcRadius = 4

function Element:Create(Text, x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetText(Text)
	self:Init()
	
	return self
	
end

function Element:SetIcon(Image)
	
	self.Image = Image
	self.Changed = true
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	self.Layout.Gradient = Element.Gradient
	self.Layout.Color = Element.Color
	self.Layout.ColorHover = Element.ColorHover
	self.Layout.ColorPressed = Element.ColorPressed
	self.Layout.BorderColor = Element.BorderColor
	self.Layout.ImageColor = Element.ImageColor
	self.Layout.TextColor = Element.TextColor
	self.Layout.TextFont = Element.TextFont
	self.Layout.Rounded = Element.Rounded
	self.Layout.ArcRadius = Element.ArcRadius
	
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
	
end

function Element:UpdateLayout()
	
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
	
end

function Element:MouseEnter(...)
	
	self.Changed = true
	Element.Base.MouseEnter(self, ...)
	
end

function Element:MouseExit(...)
	
	self.Changed = true
	Element.Base.MouseEnter(self, ...)
	
end

function Element:MousePressed(...)
	
	self.Changed = true
	Element.Base.MousePressed(self, ...)
	
end

function Element:MouseReleased(...)
	
	self.Changed = true
	Element.Base.MouseReleased(self, ...)
	
end

function Element:RoundedStencil()
	
	local Radius = self.Layout.ArcRadius
	
	love.graphics.rectangle("fill", 1, 1, self:GetWidth() - 2, self:GetHeight() - 2, Radius, Radius, Radius * 2)
	
end

function Element:RenderSkin()
	
	local Width, Height = self:GetDimensions()
	local Radius = self.Layout.ArcRadius
	
	if self.Layout.Rounded then
		
		love.graphics.setColor(self.Layout.BorderColor)
		love.graphics.rectangle("line", 0, 0, Width, Height, Radius, Radius, Radius * 2)
		
		gui.stencil(self.RoundedStencil)
		
	else
		
		love.graphics.setColor(self.Layout.BorderColor)
		love.graphics.rectangle("fill", 0, 0, Width, Height)
		
	end
	
	if self.IsPressed then
		
		love.graphics.setColor(self.Layout.ColorPressed)
		
		if self.Layout.Rounded then
			
			if self.Layout.Gradient then
				
				love.graphics.setStencilTest("greater", 0)
				love.graphics.draw(self.Layout.Gradient, 0, 0, 0, Width, Height)
				love.graphics.setStencilTest()
				
			else
				
				love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2, Radius, Radius, Radius * 2)
				
			end
			
		else
			
			love.graphics.draw(self.Layout.Gradient, 1, 1, 0, Width - 2, Height - 2)
			
		end
		
		if self.Image then
			
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(self.Image, math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2), math.floor((Height - self.Image:getHeight())/2))
			
		end
		
		self.Text:Draw(math.floor((Width - self.Text:getWidth())/2), math.floor((Height - self.Text:getHeight())/2))
		
	elseif self.IsHover then
		
		love.graphics.setColor(self.Layout.ColorHover)
		
		if self.Layout.Rounded then
			
			if self.Layout.Gradient then
				
				love.graphics.setStencilTest("greater", 0)
				love.graphics.draw(self.Layout.Gradient, 0, 0, 0, Width, Height)
				love.graphics.setStencilTest()
				
			else
				
				love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2, Radius, Radius, Radius * 2)
				
			end
			
		else
			
			love.graphics.draw(self.Layout.Gradient, 1, 1, 0, Width - 2, Height - 3)
			
		end
		
		if self.Image then
			
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(self.Image, math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2), math.floor((Height - self.Image:getHeight())/2))
			
		end
		
		self.Text:Draw(math.floor((Width - self.Text:getWidth())/2), math.floor((Height - self.Text:getHeight())/2) - 1)
		
	else
		
		love.graphics.setColor(self.Layout.Color)
		
		if self.Layout.Rounded then
			
			if self.Layout.Gradient then
				
				love.graphics.setStencilTest("greater", 0)
				love.graphics.draw(self.Layout.Gradient, 0, 0, 0, Width, Height)
				love.graphics.setStencilTest()
				
			else
				
				love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2, Radius, Radius, Radius * 2)
				
			end
			
		else
			
			love.graphics.draw(self.Layout.Gradient, 1, 1, 0, Width - 2, Height - 3)
			
		end
		
		if self.Image then
			
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(self.Image, math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2), math.floor((Height - self.Image:getHeight())/2))
			
		end
		
		self.Text:Draw((Width - self.Text:getWidth())/2, (Height - self.Text:getHeight())/2 - 1)
		
	end
	
end