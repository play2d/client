local Path, gui = ...
local TreeView = {}

TreeView.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
TreeView.TextColor = {80, 80, 80, 255}

TreeView.BorderColor = {80, 80, 80, 255}
TreeView.BackgroundColor = {255, 255, 255, 255}

local function SliderMoved(Slider)
	TreeView.UpdateLayout(Slider.Parent)
end

function TreeView:Init()
	self.Layout.TextFont = TreeView.TextFont
	self.Layout.TextColor = TreeView.TextColor
	
	self.Layout.BorderColor = TreeView.BorderColor
	self.Layout.BackgroundColor = TreeView.BackgroundColor
	
	self.Layout.Slider = gui.create("VSlider", 0, 0, 15, self:GetHeight(), self)
	self.Layout.Slider.OnValue = SliderMoved
end

function TreeView:UpdateLayout()
	local Height = self:GetHeight()
	local HeightOffset = 0
	local Altitude = 2 - self.Layout.Slider:GetValue() * (self.Layout.Slider.Max - Height) / self.Layout.Slider.Max
	for Index, Child in pairs(self.ChildrenRender) do
		if Child.Type == "TreeViewNode" then
			Child.x = 5
			Child.y = Altitude

			local ChildHeight = Child:GetHeight()
			HeightOffset = HeightOffset + ChildHeight + 2
			Altitude = Altitude + ChildHeight + 2
		end
	end
	
	self.Layout.Slider.Min = Height
	self.Layout.Slider.Max = math.max(self.Layout.Slider.Min, HeightOffset + 4)
	
	local SliderWidth = self.Layout.Slider:GetDimensions()
	self.Layout.Slider:SetHorizontalPosition(self.Width - 15)
	self.Layout.Slider:SetDimensions(SliderWidth, Height)
end

function TreeView:Render()
	local Width, Height = self:GetDimensions()
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.rectangle("line", 0, 0, Width, Height)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2)
end

function TreeView:AddChild(Child)
	if self.Layout.Slider then
		self.Layout.Slider:SetHover()
	end
end

return TreeView