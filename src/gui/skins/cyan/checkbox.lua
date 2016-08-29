local Path, gui = ...
local CheckBox = {}

CheckBox.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
CheckBox.TextColor = {80, 80, 80, 255}
CheckBox.Color = {220, 220, 220, 255}
CheckBox.HoverColor = {255, 255, 255, 255}
CheckBox.CheckImage = love.graphics.newImage(Path.."/Checked Checkbox-24.png")
CheckBox.UncheckImage = love.graphics.newImage(Path.."/Unchecked Checkbox-24.png")

function CheckBox:Init()
	self.Layout.TextFont = CheckBox.TextFont
	self.Layout.TextColor = CheckBox.TextColor
	self.Layout.Color = CheckBox.Color
	self.Layout.HoverColor = CheckBox.HoverColor
	self.Layout.CheckImage = CheckBox.CheckImage
	self.Layout.UncheckImage = CheckBox.UncheckImage
	
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(CheckBox.TextFont)
end

function CheckBox:UpdateLayout()
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(CheckBox.TextFont)
end

function CheckBox:MousePressed()
	if not self.Disabled then
		self.Status = not self.Status
		self.Changed = true
	end
end

function CheckBox:MouseEnter()
	self.Changed = true
end

function CheckBox:MouseExit()
	self.Changed = true
end

function CheckBox:Render()
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
end

return CheckBox