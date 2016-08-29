local Path, gui = ...
local Menu = {}

Menu.BackgroundColor = {230, 230, 230, 255}
Menu.BorderColor = {190, 190, 190, 255}

function Menu:Init()
	self.Layout.BackgroundColor = Menu.BackgroundColor
	self.Layout.BorderColor = Menu.BorderColor
end

function Menu:UpdateLayout()
	if self.Parent.Type == "Window" then
		self:SetDimensions(self.Parent:GetWidth() - 4, 20)
		self:SetPosition(2, 23)
	else
		self:SetDimensions(self.Parent:GetWidth(), 20)
		self:SetPosition(0, 0)
	end
	
	local x = 0
	for Index, Child in pairs(self.Children) do
		Child:SetPosition(x, 1)
		x = x + Child:GetWidth()
	end
end

function Menu:Render()
	local Width, Height = self:GetDimensions()
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.rectangle("line", 0, 0, Width, Height)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 0, 1, Width, Height - 2)
end

return Menu