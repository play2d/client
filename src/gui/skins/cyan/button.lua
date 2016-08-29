local Path, gui = ...
local Button = {}

local function RoundedStencil()
	gui.graphics.roundedbox("fill", Button.Radius, 1, 1, Button.Width - 2, Button.Height - 2)
end

Button.Image = love.image.newImageData(1, 20)
for y = 0, 19 do
	Button.Image:setPixel(0, y, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19)
end
Button.Image = love.graphics.newImage(Button.Image)
Button.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Button.TextColor = {80, 80, 80, 255}

Button.Color = {255, 255, 255, 255}
Button.ColorHover = {240, 240, 240, 255}
Button.ColorPressed = {220, 220, 220, 255}
Button.BorderColor = {100, 100, 100, 255}
Button.ImageColor = {255, 255, 255, 255}
Button.Rounded = false
Button.ArcRadius = 4

function Button:Init()
	self.Layout.Image = Button.Image
	self.Layout.Color = Button.Color
	self.Layout.ColorHover = Button.ColorHover
	self.Layout.ColorPressed = Button.ColorPressed
	self.Layout.BorderColor = Button.BorderColor
	self.Layout.ImageColor = Button.ImageColor
	self.Layout.TextColor = Button.TextColor
	self.Layout.TextFont = Button.TextFont
	self.Layout.Rounded = Button.Rounded
	self.Layout.ArcRadius = Button.ArcRadius
	
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
end

function Button:UpdateLayout()
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
end

function Button:MouseEnter()
	self.Changed = true
end

function Button:MouseExit()
	self.Changed = true
end

function Button:MousePressed()
	self.Changed = true
end

function Button:MouseReleased()
	self.Changed = true
end

function Button:Render()
	local Width, Height = self:GetDimensions()
	local Radius = self.Layout.ArcRadius
	
	if self.Layout.Rounded then
		Button.Width, Button.Height, Button.Radius = Width, Height, Radius
	
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
end

return Button