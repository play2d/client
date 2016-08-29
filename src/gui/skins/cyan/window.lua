local Path, gui = ...
local Window = {}

Window.TitleImage = love.image.newImageData(1, 23)
Window.TitleFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 14)
Window.TitleColor = {255, 255, 255, 255}
Window.TitleBackgroundColor = {255, 255, 255, 255}
Window.TitleDividerColor = {100, 100, 100, 255}
Window.CloseImage = love.graphics.newImage(Path.."/Delete-16.png")

Window.BackgroundColor = {245, 245, 245, 255}
Window.Border1Color = {100, 100, 100}
Window.Border2Color = {110, 160, 255}

Window.CloseButtonColor = {255, 80, 80, 255}
Window.CloseButtonColorHover = {255, 120, 120, 255}
Window.CloseButtonColorPressed = {200, 50, 50, 255}

for y = 0, Window.TitleImage:getHeight() - 1 do
	Window.TitleImage:setPixel(0, y,
		40 * 6/7 + 120 * (23 - y) * 1/7 * 1/23, 
		150 * 6/7 + 230 * (23 - y) * 1/7 * 1/23,
		200 * 6/7 + 400 * (23 - y) * 1/7 * 1/23
	)
end
Window.TitleImage = love.graphics.newImage(Window.TitleImage)

local function CloseButton(Button)
	local Window = Button.Parent
	if Window.Closeable and Button.IsHover then
		Window.Hidden = true
	end
end

local function BackgroundStencil()
	love.graphics.arc("fill", 5, 5, 5, -math.pi, -math.pi/2, 4)
	love.graphics.arc("fill", Window.Width - 5, 5, 5, -math.pi/2, 0, 4)
	love.graphics.rectangle("fill", 5, 0, Window.Width - 10, 5)
	love.graphics.rectangle("fill", 0, 5, Window.Width, 20)
end

function Window:Init()
	self.Text:SetFont(Window.TitleFont)
	
	self.Layout.TitleImage = Window.TitleImage
	self.Layout.TitleFont = Window.TitleFont
	self.Layout.TitleColor = Window.TitleColor
	self.Layout.TitleBackgroundColor = Window.TitleBackgroundColor
	self.Layout.TitleDividerColor = Window.TitleDividerColor
	self.Layout.CloseImage = Window.CloseImage
	
	self.Layout.BackgroundColor = Window.BackgroundColor
	self.Layout.Border1Color = Window.Border1Color
	self.Layout.Border2Color = Window.Border2Color
	
	self.Layout.CloseButton = gui.create("Button", "", 0, 0, 16, 16, self)
	self.Layout.CloseButton.Image = self.Layout.CloseImage
	self.Layout.CloseButton.Layout.Color = Window.CloseButtonColor
	self.Layout.CloseButton.Layout.ColorHover = Window.CloseButtonColorHover
	self.Layout.CloseButton.Layout.ColorPressed = Window.CloseButtonColorPressed
	self.Layout.CloseButton.Layout.Rounded = true
	self.Layout.CloseButton.Layout.ArcRadius = 4
	self.Layout.CloseButton.OnMouseReleased = CloseButton
end

function Window:UpdateLayout()
	self.Text:SetColor(unpack(self.Layout.TitleColor))
	self.Text:SetFont(self.Layout.TitleFont)
	
	local Width, Height = self:GetDimensions()
	self.Layout.CloseButton:SetPosition(Width - 19, 3)
	self.Layout.CloseButton.Image = self.Layout.CloseImage
	self.Layout.CloseButton.Visible = self.Closeable
end

function Window:Render(dt)
	local Width, Height = self:GetDimensions()
	
	Window.Width = Width
	love.graphics.stencil(BackgroundStencil, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	
	love.graphics.setColor(self.Layout.TitleBackgroundColor)
	love.graphics.draw(Window.TitleImage, 0, 0, 0, Width, 1)
	love.graphics.setStencilTest()
	
	love.graphics.setColor(self.Layout.TitleDividerColor)
	love.graphics.line(0, 23, Width, 23)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 0, 23, Width, Height - 23)
	
	love.graphics.setColor(self.Layout.Border1Color)
	love.graphics.line(1, 23, 1, Height - 1)
	love.graphics.line(Width - 1, 23, Width - 1, Height - 1)
	love.graphics.line(1, Height - 1, Width - 1, Height - 1)
	
	love.graphics.setColor(self.Layout.Border2Color)
	love.graphics.line(0, 23, 0, Height)
	love.graphics.line(Width, 23, Width, Height)
	love.graphics.line(0, Height, Width, Height)

	self.Text:Draw(5, (Window.TitleImage:getHeight() - self.Text:getHeight())/2)
end

return Window