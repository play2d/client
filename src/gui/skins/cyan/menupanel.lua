local Path, gui = ...
local MenuPanel = {}

MenuPanel.BorderColor = {80, 80, 80, 255}
MenuPanel.BackgroundColor = {220, 220, 220, 255}

function MenuPanel:Init()
	self.Layout.BorderColor = MenuPanel.BorderColor
	self.Layout.BackgroundColor = MenuPanel.BackgroundColor
end

function MenuPanel:UpdateLayout()
	local Width = 0
	local Altitude = 0
	
	for Index, Child in pairs(self.Children) do
		if Child.Type == "MenuButton" then
			local ChildWidth = Child:GetWidth()
			if ChildWidth > Width then
				Width = ChildWidth
			end
		end
		Child:SetPosition(3, Altitude)
		Altitude = Altitude + Child:GetHeight()
	end
	
	for Index, Child in pairs(self.Children) do
		if Child.Type == "MenuSpacer" then
			Child.Width = Width
		end
	end
	self:SetDimensions(Width + 6, Altitude)
end

function MenuPanel:Render()
	local Width, Height = self:GetDimensions()
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.rectangle("line", 0, 0, Width, Height)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2)
end

return MenuPanel