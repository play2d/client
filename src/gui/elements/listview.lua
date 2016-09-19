local gui = ...
local Element = gui.register("ListView", "Container")

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}

Element.BorderColor = {80, 80, 80, 255}
Element.BackgroundColor = {255, 255, 255, 255}

Element.ArcRadius = 6

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

local function SliderMoved(Slider)
	
	Slider.Parent.Changed = true
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	local Width, Height = self:GetDimensions()
	
	self.Layout.TextFont = Element.TextFont
	self.Layout.TextColor = Element.TextColor
	
	self.Layout.BorderColor = Element.BorderColor
	self.Layout.BackgroundColor = Element.BackgroundColor
	
	self.Layout.Slider = gui.create("VSlider", Width - 15, 0, 15, Height, self)
	self.Layout.Slider.OnValue = SliderMoved
	
	self.Layout.ArcRadius = Element.ArcRadius
	
	self.Selected = 0
	self.Item = {}
	
end

function Element:SetItem(Index, Text)
	
	if type(Text) == "string" then
		
		self.Item[Index] = gui.CreateText(Text, self.Layout.TextFont, unpack(self.Layout.TextColor))
		self:UpdateItems()
		
	elseif Text == nil then
		
		self.Item[Index] = nil
		self:UpdateItems()
		
	end
	
	return self
	
end

function Element:RoundedScissor()
	
	local ArcRadius = self.Layout.ArcRadius
	
	love.graphics.rectangle("fill", 0, 0, self:GetWidth(), self:GetHeight(), ArcRadius, ArcRadius, ArcRadius)
	
end

function Element:AddItem(Text)
	
	return self:SetItem(#self.Item + 1, Text)
	
end

function Element:Select(Index)
	
	self.Selected = Index or 0
	self.Changed = true
	
end

function Element:OnSelect(Item)
	
end

function Element:MouseMoved(...)
	
	Element.Base.MouseMoved(self, ...)
	self.Changed = true
	
end

function Element:MouseExit(...)
	
	Element.Base.MouseExit(self, ...)
	self.Changed = true
	
end

function Element:WheelMoved(x, y)
	
	Element.Base.MouseMoved(x, y)
	self.Layout.Slider:SetValue(self.Layout.Slider.Value - y * 5 * self.Layout.Slider.Max / self.Height)
	self.Changed = true
	
end

function Element:MousePressed(MouseX, MouseY, Button, IsTouch)
	
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

function Element:UpdateItems()
	
	local HeightOffset = 0
	
	for i, Item in pairs(self.Item) do
		
		HeightOffset = HeightOffset + Item:getHeight()
		
	end
	
	self.Layout.Slider.Min = self:GetHeight()
	self.Layout.Slider.Max = math.max(self.Layout.Slider.Min, HeightOffset + 4)
	self.Changed = true
	
end

function Element:UpdateLayout()
	
	local Width, Height = self:GetDimensions()
	
	for i, Item in pairs(self.Item) do
		Item:SetFont(self.Layout.TextFont)
		Item:SetColor(unpack(self.Layout.TextColor))
	end
	
	self.Layout.Slider:SetDimensions(15, Height)
	self.Layout.Slider:SetPosition(Width - 15, 0)
	self.Layout.Slider.Hidden = self.Layout.Slider.Min >= self.Layout.Slider.Max
	
end

function Element:RenderSkin()
	
	local Width, Height = self:GetDimensions()
	local ArcRadius = self.Layout.ArcRadius
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.rectangle("line", 1, 1, Width - 2, Height - 2, ArcRadius, ArcRadius, ArcRadius)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2, ArcRadius, ArcRadius, ArcRadius)
	
	gui.stencil(self.RoundedScissor)
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