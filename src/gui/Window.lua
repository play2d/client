local TWindow = {}
local TWindowMetatable = {__index = TWindow}
TWindow.Type = "Window"
TWindow.Text = "Text"
setmetatable(TWindow, gui.TGadgetMetatable)

function gui.CreateWindow(Text, x, y, Width, Height, Parent, Closeable)
	local Window = TWindow.New()
	if Parent:AddGadget(Window) then
		Window.Closeable = Closeable
		Window:SetPosition(x, y)
		Window:SetDimensions(Width, Height)
		Window:SetText(Text)
		return Window:Init()
	end
end

function TWindow.New()
	return setmetatable({}, TWindowMetatable)
end

function TWindow:Init()
	self.Gadgets = {}
	self.GadgetsOrder = {}
	return self
end

function TWindow:Render(dt)
	if not self.Hidden then
		local x, y = self:GetPosition()
		local Width, Height = self:GetDimensions()
		local Theme = self:GetTheme()
		local CloseImage = Theme.CloseImage
		local CloseImageHeight = CloseImage:getHeight()
		love.graphics.setScissor(x, y, Width, Height)

		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)

		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)

		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, CloseImageHeight)

		love.graphics.setColor(unpack(Theme.TitleTop))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, CloseImageHeight/2)

		love.graphics.setColor(unpack(Theme.TitleBottom))
		love.graphics.rectangle("fill", x + 1, y + CloseImageHeight/2, Width - 2, CloseImageHeight/2)

		love.graphics.setColor(unpack(Theme.TitleText))
		local Font = self:GetFont()
		love.graphics.setFont(Font)
		love.graphics.print(self.Text,
			math.floor(x + (Width - Font:getWidth(self.Text))/2),
			math.floor(y + (CloseImageHeight - Font:getHeight())/2)
		)

		if self.Closeable then
			local CloseImageWidth = CloseImage:getWidth()
			if self:GetHoverAll() == self and self:MouseHoverArea(Width - CloseImageWidth, 0, CloseImageWidth, CloseImageHeight) then
				love.graphics.setColor(unpack(Theme.CloseHover))
			else
				love.graphics.setColor(unpack(Theme.CloseDefault))
			end
			love.graphics.draw(CloseImage, x + Width - CloseImageWidth, y)
		end
		self:RenderGadgets(dt)
	end
end

function TWindow:MouseDropped(x, y)
	if self.Grabbed then
		self.Grabbed = nil
		self.Dropped = {x = x - self:x(), y = y - self:y()}
		self:OnDrop(self.Dropped.x, self.Dropped.y)

		if self.Closeable then
			local Theme = self:GetTheme()
			local CloseImage = Theme.CloseImage
			local Width = self:GetWidth()
			if self.Dropped.x >= Width - CloseImage:getWidth() and self.Dropped.y >= 0 and self.Dropped.y <= CloseImage:getHeight() and self.Dropped.x <= Width then
				self:Hide()
			end
		end
	end
end

function TWindow:MouseMove(x, y, dx, dy)
	if not self.Disabled and not self.Hidden then
		local Theme = self:GetTheme()
		local CloseImage = Theme.CloseImage
		if self.Grabbed.y <= CloseImage:getHeight() then
			if not self.Closeable or self.Closeable and self.Grabbed.x <= self:GetWidth() - CloseImage:getWidth() then
				self:SetPosition(self.Offset.x + dx, self.Offset.y + dy)
			end
		end
	end
end
