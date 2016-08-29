local Path, gui = ...
local ListBox = {}

ListBox.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
ListBox.TextColor = {80, 80, 80, 255}

ListBox.BorderColor = {80, 80, 80, 255}
ListBox.BackgroundColor = {255, 255, 255, 255}

local function RoundedScissor()
	gui.graphics.roundedbox("fill", 4, 0, 0, ListBox.Width, ListBox.Height)
end

local function SliderMoved(Slider)
	Slider.Parent.Changed = true
end

function ListBox:Init()
	local Width, Height = self:GetDimensions()
	
	self.Layout.TextFont = ListBox.TextFont
	self.Layout.TextColor = ListBox.TextColor
	
	self.Layout.BorderColor = ListBox.BorderColor
	self.Layout.BackgroundColor = ListBox.BackgroundColor
	
	self.Layout.Slider = gui.create("VSlider", Width - 15, 0, 15, Height, self)
	self.Layout.Slider.OnValue = SliderMoved
end

function ListBox:UpdateLayout()
	local Width, Height = self:GetDimensions()
	
	for i, Item in pairs(self.Item) do
		Item:SetFont(self.Layout.TextFont)
		Item:SetColor(unpack(self.Layout.TextColor))
	end
	
	self.Layout.Slider:SetDimensions(15, Height)
	self.Layout.Slider:SetPosition(Width - 15, 0)
	self.Layout.Slider.Hidden = self.Layout.Slider.Min >= self.Layout.Slider.Max
end

function ListBox:MouseMoved()
	self.Changed = true
end

function ListBox:MouseExit()
	self.Changed = true
end

function ListBox:WheelMoved(x, y)
	self.Layout.Slider:SetValue(self.Layout.Slider.Value - y * 5 * self.Layout.Slider.Max / self.Height)
	self.Changed = true
end

function ListBox:MousePressed(MouseX, MouseY, Button, IsTouch)
	if Button == 1 then
		local Width, Height = self:GetDimensions()
		local HeightOffset = 2 - self.Layout.Slider:GetValue() * (self.Layout.Slider.Max - Height) / self.Layout.Slider.Max
		for i, Item in pairs(self.Item) do
			local ItemHeight = Item:getHeight()
			if HeightOffset >= -ItemHeight then
				if HeightOffset > Height then
					break
				elseif MouseY > HeightOffset and MouseY <= HeightOffset + ItemHeight then
					self:OnSelect(i)
					self.Selected = i
					self.Changed = true
					break
				end
			end
			HeightOffset = HeightOffset + ItemHeight
		end
	end
end

function ListBox:UpdateItems()
	local HeightOffset = 0
	for i, Item in pairs(self.Item) do
		HeightOffset = HeightOffset + Item:getHeight()
	end
	
	self.Layout.Slider.Min = self:GetHeight()
	self.Layout.Slider.Max = math.max(self.Layout.Slider.Min, HeightOffset + 4)
	self.Changed = true
end

function ListBox:Render()
	local Width, Height = self:GetDimensions()
	ListBox.Width, ListBox.Height = Width, Height
	
	love.graphics.setColor(self.Layout.BorderColor)
	gui.graphics.roundedbox("line", 4, 1, 1, Width - 2, Height - 2)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	gui.graphics.roundedbox("fill", 4, 1, 1, Width - 2, Height - 2)
	
	love.graphics.stencil(RoundedScissor)
	love.graphics.setStencilTest("greater", 0)
	
	local HeightOffset = 2 - self.Layout.Slider:GetValue() * (self.Layout.Slider.Max - Height) / self.Layout.Slider.Max
	for i, Item in pairs(self.Item) do
		local ItemHeight = Item:getHeight()
		
		if HeightOffset > -ItemHeight then
			if HeightOffset > Height then
				break
			end
			
			Item:Draw(5, HeightOffset)
			
			if self.Selected == i then
				love.graphics.setColor(0, 0, 0, 70)
				love.graphics.rectangle("fill", 0, HeightOffset, Width, ItemHeight)
			elseif self.IsHover and self.IsHover.y > HeightOffset and self.IsHover.y <= HeightOffset + ItemHeight then
				love.graphics.setColor(75, 75, 75, 70)
				love.graphics.rectangle("fill", 0, HeightOffset, Width, ItemHeight)
			end
		end
		
		HeightOffset = HeightOffset + ItemHeight
	end
	love.graphics.setStencilTest()
end

return ListBox