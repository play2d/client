local gui = ...
local Element = gui.register("Button", "Element")
local Button

Element.Image = love.image.newImageData(1, 20)
for y = 0, 19 do
	Element.Image:setPixel(0, y, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19)
end
Element.Image = love.graphics.newImage(Element.Image)
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

local function RoundedStencil()
	gui.graphics.roundedbox("fill", Button.Layout.ArcRadius, 1, 1, Button:GetWidth() - 2, Button:GetHeight() - 2)
end

function Element:Init()
	Element.Base.Init(self)
	
	self.Layout.Image = Element.Image
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

function Element:RenderSkin()
	love.graphics.setCanvas(self.Canvas)
	love.graphics.clear(0, 0, 0, 0)
	
	local Width, Height = self:GetDimensions()
	local Radius = self.Layout.ArcRadius
	
	Button = self
	
	if self.Layout.Rounded then
		love.graphics.setColor(self.Layout.BorderColor)
		gui.graphics.roundedbox("line", self.Layout.ArcRadius, 1, 1, Width - 2, Height - 2)
		
		love.graphics.stencil(RoundedStencil)
	else
		love.graphics.setColor(self.Layout.BorderColor)
		love.graphics.rectangle("line", 1, 1, Width - 2, Height - 2)
	end
	
	if self.IsPressed then
		love.graphics.setColor(self.Layout.ColorPressed)
		
		if self.Layout.Rounded then
			if self.Layout.Image then
				love.graphics.setStencilTest("greater", 0)
				love.graphics.draw(self.Layout.Image, 0, 0, 0, Width, Height/20)
				love.graphics.setStencilTest()
			else
				gui.graphics.roundedbox("fill", Radius, 1, 1, Width - 2, Height - 2)
			end
		else
			love.graphics.draw(self.Layout.Image, 1, 1, 0, Width - 2, (Height - 2)/20)
		end
		
		if self.Image then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(self.Image, math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2), math.floor((Height - self.Image:getHeight())/2))
		end
		
		self.Text:Draw(math.floor((Width - self.Text:getWidth())/2), math.floor((Height - self.Text:getHeight())/2))
	elseif self.IsHover then
		love.graphics.setColor(self.Layout.ColorHover)
		
		if self.Layout.Rounded then
			if self.Layout.Image then
				love.graphics.setStencilTest("greater", 0)
				love.graphics.draw(self.Layout.Image, 0, 0, 0, Width, Height/20)
				love.graphics.setStencilTest()
			else
				gui.graphics.roundedbox("fill", Radius, 1, 1, Width - 2, Height - 2)
			end
		else
			love.graphics.draw(self.Layout.Image, 1, 1, 0, Width - 2, (Height - 3)/20)
		end
		
		if self.Image then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(self.Image, math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2), math.floor((Height - self.Image:getHeight())/2))
		end
		
		self.Text:Draw(math.floor((Width - self.Text:getWidth())/2), math.floor((Height - self.Text:getHeight())/2) - 1)
	else
		love.graphics.setColor(self.Layout.Color)
		
		if self.Layout.Rounded then
			if self.Layout.Image then
				love.graphics.setStencilTest("greater", 0)
				love.graphics.draw(self.Layout.Image, 0, 0, 0, Width, Height/20)
				love.graphics.setStencilTest()
			else
				gui.graphics.roundedbox("fill", Radius, 1, 1, Width - 2, Height - 2)
			end
		else
			love.graphics.draw(self.Layout.Image, 1, 1, 0, Width - 2, (Height - 3)/20)
		end
		
		if self.Image then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(self.Image, math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2), math.floor((Height - self.Image:getHeight())/2))
		end
		
		self.Text:Draw((Width - self.Text:getWidth())/2, (Height - self.Text:getHeight())/2 - 1)
	end
	
	love.graphics.setCanvas()
end