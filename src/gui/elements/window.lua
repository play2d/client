local gui = ...
local Element = gui.register("Window", "Container")

Element.Closeable = true

Element.TitleGradient = love.graphics.newMesh(
	{
		{
			0, 0,
			0, 0,
			51.428571428571, 161.42857142857, 228.57142857143
		},
		{
			1, 0,
			1, 0,
			51.428571428571, 161.42857142857, 228.57142857143
		},
		{
			1, 1,
			1, 1,
			35.031055900621, 130, 173.91304347826
		},
		{
			0, 1,
			0, 1,
			35.031055900621, 130, 173.91304347826
		}
	}
, "fan", "static")

Element.TitleFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 14)
Element.TitleHeight = 25
Element.TitleColor = {255, 255, 255, 255}
Element.TitleBackgroundColor = {255, 255, 255, 255}
Element.TitleDividerColor = {100, 100, 100, 255}
Element.CloseImage = love.graphics.newImage(gui.Path.."/Images/Delete-16.png")

Element.BackgroundColor = {245, 245, 245, 255}
Element.BorderColor1 = {100, 100, 100}
Element.BorderColor2 = {110, 160, 255}

Element.CloseButtonColor = {255, 80, 80, 255}
Element.CloseButtonColorHover = {255, 120, 120, 255}
Element.CloseButtonColorPressed = {200, 50, 50, 255}

local function CloseButton(Button)
	
	local self = Button.Parent
	
	if self.Closeable and Button.IsHover then
		
		self.Hidden = true
		
	end
	
end

function Element:Create(Text, x, y, Width, Height, Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetText(Text)
	self:Init()
	
	return self
end

function Element:Init()
	
	Element.Base.Init(self)
	
	self.Text:SetFont(Element.TitleFont)
	
	self.Layout.TitleGradient = Element.TitleGradient
	self.Layout.TitleHeight = Element.TitleHeight
	self.Layout.TitleFont = Element.TitleFont
	self.Layout.TitleColor = Element.TitleColor
	self.Layout.TitleBackgroundColor = Element.TitleBackgroundColor
	self.Layout.TitleDividerColor = Element.TitleDividerColor
	self.Layout.CloseImage = Element.CloseImage
	
	self.Layout.BackgroundColor = Element.BackgroundColor
	self.Layout.BorderColor1 = Element.BorderColor1
	self.Layout.BorderColor2 = Element.BorderColor2
	
	self.Layout.CloseButton = gui.create("Button", "", 0, 0, 16, 16, self)
	self.Layout.CloseButton.Image = self.Layout.CloseImage
	self.Layout.CloseButton.Layout.Color = Element.CloseButtonColor
	self.Layout.CloseButton.Layout.ColorHover = Element.CloseButtonColorHover
	self.Layout.CloseButton.Layout.ColorPressed = Element.CloseButtonColorPressed
	self.Layout.CloseButton.Layout.Rounded = true
	self.Layout.CloseButton.Layout.ArcRadius = 4
	self.Layout.CloseButton.OnMouseReleased = CloseButton
	
end

function Element:UpdateLayout()
	
	self.Text:SetColor(unpack(self.Layout.TitleColor))
	self.Text:SetFont(self.Layout.TitleFont)
	
	local Width, Height = self:GetDimensions()
	
	self.Layout.CloseButton:SetPosition(Width - 19, 3)
	self.Layout.CloseButton.Image = self.Layout.CloseImage
	self.Layout.CloseButton.Visible = self.Closeable
	
end

function Element:BackgroundStencil()
	
	local Width = self:GetWidth()
	
	love.graphics.arc("fill", 5, 5, 5, -math.pi, -math.pi/2, 4)
	love.graphics.arc("fill", Width - 5, 5, 5, -math.pi/2, 0, 4)
	love.graphics.rectangle("fill", 5, 0, Width - 10, 5)
	love.graphics.rectangle("fill", 0, 5, Width, self.Layout.TitleHeight)
	
end

function Element:RenderSkin(dt)
	
	local Width, Height = self:GetDimensions()
	
	gui.stencil(self.BackgroundStencil, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	
	love.graphics.setColor(self.Layout.TitleBackgroundColor)
	love.graphics.draw(self.Layout.TitleGradient, 0, 0, 0, Width, self.Layout.TitleHeight)
	love.graphics.setStencilTest()
	
	love.graphics.setColor(self.Layout.TitleDividerColor)
	love.graphics.line(0, self.Layout.TitleHeight, Width, self.Layout.TitleHeight)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 0, self.Layout.TitleHeight, Width, Height - self.Layout.TitleHeight)
	
	love.graphics.setColor(self.Layout.BorderColor1)
	love.graphics.line(1, self.Layout.TitleHeight, 1, Height - 1)
	love.graphics.line(Width - 1, self.Layout.TitleHeight, Width - 1, Height - 1)
	love.graphics.line(1, Height - 1, Width - 1, Height - 1)
	
	love.graphics.setColor(self.Layout.BorderColor2)
	love.graphics.line(0, self.Layout.TitleHeight, 0, Height)
	love.graphics.line(Width, self.Layout.TitleHeight, Width, Height)
	love.graphics.line(0, Height, Width, Height)

	self.Text:Draw(5, (self.Layout.TitleHeight - self.Text:getHeight())/2)
	
end

function Element:MouseDrag(x, y, dx, dy)
	
	if self.GrabWindow and not self.Disabled then
		
		self:SetPosition(self:GetHorizontalPosition() + dx, self:GetVerticalPosition() + dy)
		
	end
	
	Element.Base.MouseDrag(self, x, y, dx, dy)
end

function Element:CanGrab(x, y, Button, IsTouch)
	
	return y < 24
	
end

function Element:MousePressed(x, y, Button, IsTouch)
	
	if not self.Disabled then
		
		if self:CanGrab(x, y, Button, IsTouch) then
			
			self.GrabWindow = true
			
		end
		
	end
	
	Element.Base.MousePressed(self, x, y, Button, IsTouch)
	
end

function Element:MouseReleased(x, y, Button, IsTouch)
	
	self.GrabWindow = nil
	Element.Base.MouseReleased(self, x, y, Button, IsTouch)
	
end

function Element:SetCloseable(Closeable)
	
	self.Closeable = Closeable
	
end

function Element:GetCloseable()
	
	return self.Closeable
	
end