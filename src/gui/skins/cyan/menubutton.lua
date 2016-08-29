local Path, gui = ...
local MenuButton = {}

MenuButton.ColorPressed = {200, 200, 255, 255}
MenuButton.ColorBorderPressed = {190, 190, 255, 255}

MenuButton.ColorHover = {220, 220, 255, 255}
MenuButton.ColorBorderHover = {210, 210, 255, 255}

MenuButton.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
MenuButton.TextColor = {80, 80, 80, 255}

function MenuButton:Init()
	self.Layout.TextFont = MenuButton.TextFont
	self.Layout.TextColor = MenuButton.TextColor
	
	self.Layout.ColorPressed = MenuButton.ColorPressed
	self.Layout.ColorBorderPressed = MenuButton.ColorBorderPressed
	
	self.Layout.ColorHover = MenuButton.ColorHover
	self.Layout.ColorBorderHover = MenuButton.ColorBorderHover
end

function MenuButton:UpdateLayout()
	self:SetDimensions(self.Text:getWidth() + 5, 18)
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
	
	if self.Parent.Type == "MenuPanel" then
		self.DropDown:SetPosition(self.Parent:GetWidth() - 2, 0)
	elseif self.Parent.Type == "Menu" then
		self.DropDown:SetPosition(0, self:GetHeight())
	end
end

function MenuButton:Render()
	local Width, Height = self:GetDimensions()
	
	if self.IsPressed then
		love.graphics.setColor(self.Layout.ColorBorderPressed)
		love.graphics.rectangle("line", 0, 0, Width, Height)
		
		love.graphics.setColor(self.Layout.ColorPressed)
		love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2)
	elseif self.IsHover then
		love.graphics.setColor(self.Layout.ColorBorderHover)
		love.graphics.rectangle("line", 0, 0, Width, Height)
		
		love.graphics.setColor(self.Layout.ColorHover)
		love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2)
	end
	
	self.Text:Draw((Width - self.Text:getWidth())/2, (Height - self.Text:getHeight())/2)
end

function MenuButton:MouseEnter()
	self.Changed = true
end

function MenuButton:MouseExit()
	self.Changed = true
end

function MenuButton:MousePressed()
	self.Changed = true
end

function MenuButton:MouseReleased()
	self.Changed = true
end

return MenuButton