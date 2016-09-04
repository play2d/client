local gui = ...
local Element = gui.register("CheckBox", "Element")

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}
Element.Color = {220, 220, 220, 255}
Element.HoverColor = {255, 255, 255, 255}
Element.CheckImage = love.graphics.newImage(gui.Path.."/Images/Checked Checkbox-24.png")
Element.UncheckImage = love.graphics.newImage(gui.Path.."/Images/Unchecked Checkbox-24.png")

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
	
	self.Layout.TextFont = CheckBox.TextFont
	self.Layout.TextColor = CheckBox.TextColor
	self.Layout.Color = CheckBox.Color
	self.Layout.HoverColor = CheckBox.HoverColor
	self.Layout.CheckImage = CheckBox.CheckImage
	self.Layout.UncheckImage = CheckBox.UncheckImage
	
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
end

function Element:UpdateLayout()
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
end

function Element:IsChecked()
	return self.Status ~= nil
end

function Element:SetChecked(Checked)
	if Checked then
		self.Status = true
	else
		self.Status = nil
	end
	self.Changed = true
end

function Element:MousePressed(...)
	if not self.Disabled then
		self.Status = not self.Status
		self.Changed = true
	end
	Element.Base.MousePressed(self, ...)
end

function Element:MouseEnter(...)
	self.Changed = true
	Element.Base.MouseEnter(self, ...)
end

function Element:MouseExit(...)
	self.Changed = true
	Element.Base.MouseExit(self, ...)
end

function Element:RenderSkin()
	love.graphics.setCanvas(self.Canvas)
	love.graphics.clear(0, 0, 0, 0)
	
	local Width, Height = self:GetDimensions()

	if self.IsHover then
		love.graphics.setColor(self.Layout.HoverColor)
	else
		love.graphics.setColor(self.Layout.Color)
	end
	
	if self.Status then
		love.graphics.draw(self.Layout.CheckImage, 0, 0, 0, Height/24, Height/24)
	else
		love.graphics.draw(self.Layout.UncheckImage, 0, 0, 0, Height/24, Height/24)
	end
	
	self.Text:Draw(Height + 3, (Height - self.Text:getHeight())/2)
	
	love.graphics.setCanvas()
end