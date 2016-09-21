local gui = ...
local Element = gui.register("ListView", "Container")

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}

Element.BorderColor = {80, 80, 80, 255}
Element.BackgroundColor = {255, 255, 255, 255}

Element.ArcRadius = 6
Element.LineWidth = 1

Element.Gradient = love.graphics.newMesh(
	{
		{
			0, 0,
			0, 0,
			180, 180, 180, 255
		},
		{
			1, 0,
			1, 0,
			180, 180, 180, 255
		},
		{
			1, 1,
			1, 1,
			208, 208, 208, 255
		},
		{
			0, 1,
			0, 1,
			208, 208, 208, 255
		}
	}
, "fan", "static")

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
	self.Layout.LineWidth = Element.LineWidth
	
	self.Layout.Gradient = Element.Gradient
	
	self.Selected = 0
	self.Column = {}
	
end

function Element:CreateColumn(Text, Width)
	
	local Column = {
		Text = Text,
		Width = Width,
		Items = {},
	}
	
	local Index = #self.Column + 1
	
	self.Column[Index] = Column
	
	return Index
	
end

function Element:SetItem(Column, Index, Text)
	
	if type(Text) == "string" then
		
		if self.Column[Column] then
		
			self.Column[Column].Items[Index] = gui.CreateText(Text, self.Layout.TextFont, unpack(self.Layout.TextColor))
			self:UpdateItems()
			
		end
		
	elseif Text == nil then
		
		if self.Column[Column] then
		
			self.Column[Column].Items[Index] = nil
			self:UpdateItems()
			
		end
		
	end
	
	return self
	
end

function Element:RoundedScissor()
	
	local ArcRadius = self.Layout.ArcRadius
	
	love.graphics.rectangle("fill", 1, 1, self:GetWidth() - 2, self:GetHeight() - 2, ArcRadius, ArcRadius, ArcRadius)
	
end

function Element:AddItem(Column, Text)
	
	local ColumnTable = self.Column[Column]
	
	if ColumnTable then
	
		return self:SetItem(Column, #ColumnTable.Items + 1, Text)
		
	end
	
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
	
	Element.Base.WheelMoved(self, x, y)
	self.Layout.Slider:SetValue(self.Layout.Slider.Value - y * 5 * self.Layout.Slider.Max / self.Height)
	self.Changed = true
	
end

function Element:MousePressed(MouseX, MouseY, Button, IsTouch)
	
	if Button == 1 then
		
		local Width, Height = self:GetDimensions()
		local HeightOffset = 2 + self.Layout.TextFont:getHeight() - self.Layout.Slider:GetValue() * (self.Layout.Slider.Max - Height) / self.Layout.Slider.Max
		
		local ItemCount = 0
		
		for n, Column in pairs(self.Column) do
			
			if #Column.Items > ItemCount then
				
				ItemCount = #Column.Items
				
			end
			
		end
		
		for i = 1, ItemCount do
			
			local ItemHeight = 0
		
			for n, Column in pairs(self.Column) do
				
				local ColumnItem = Column.Items[i]
				
				if ColumnItem then
				
					local ColumnItemHeight = ColumnItem:getHeight()
					
					if ColumnItemHeight > ItemHeight then
						
						ItemHeight = ColumnItemHeight
						
					end
					
				end
				
			end
				
			
			if HeightOffset >= -ItemHeight then
				
				for n, Column in pairs(self.Column) do
					
					if HeightOffset > Height then
						
						return
						
					elseif MouseY > HeightOffset and MouseY <= HeightOffset + ItemHeight then
						
						self:OnSelect(i)
						self.Selected = i
						self.Changed = true
						
						return
						
					end
					
				end
				
			end
			
			HeightOffset = HeightOffset + ItemHeight
			
		end
		
	end
	
end

function Element:UpdateItems()
	
	local TotalHeightOffset = 0
	
	for n, Column in pairs(self.Column) do
	
		local HeightOffset = self.Layout.TextFont:getHeight()
	
		for i, Item in pairs(Column.Items) do
			
			HeightOffset = HeightOffset + Item:getHeight()
			
		end
		
		if HeightOffset > TotalHeightOffset then
			
			TotalHeightOffset = HeightOffset
			
		end
		
	end
	
	self.Layout.Slider.Min = self:GetHeight()
	self.Layout.Slider.Max = math.max(self.Layout.Slider.Min, TotalHeightOffset + 4)
	self.Changed = true
	
end

function Element:UpdateLayout()
	
	local Width, Height = self:GetDimensions()
	
	for n, Column in pairs(self.Column) do
	
		for i, Item in pairs(Column.Items) do
			
			Item:SetFont(self.Layout.TextFont)
			Item:SetColor(unpack(self.Layout.TextColor))
			
		end
		
	end
	
	self.Layout.Slider:SetDimensions(15, Height)
	self.Layout.Slider:SetPosition(Width - 15, 0)
	self.Layout.Slider.Hidden = self.Layout.Slider.Min >= self.Layout.Slider.Max
	
end

function Element:RenderSkin()
	
	love.graphics.setLineWidth(self.Layout.LineWidth)
	
	local Width, Height = self:GetDimensions()
	local ArcRadius = self.Layout.ArcRadius
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.rectangle("line", 1, 1, Width - 2, Height - 2, ArcRadius, ArcRadius, ArcRadius)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2, ArcRadius, ArcRadius, ArcRadius)
	
	gui.stencil(self.RoundedScissor)
	love.graphics.setStencilTest("greater", 0)
	
	local HeightOffset = 2 + self.Layout.TextFont:getHeight() - self.Layout.Slider:GetValue() * (self.Layout.Slider.Max - Height) / self.Layout.Slider.Max
	
	local ItemCount = 0
	
	for n, Column in pairs(self.Column) do
		
		if #Column.Items > ItemCount then
			
			ItemCount = #Column.Items
			
		end
		
	end
	
	for i = 1, ItemCount do
		
		local ItemHeight = 0
		
		for n, Column in pairs(self.Column) do
			
			local ColumnItem = Column.Items[i]
			
			if ColumnItem then
			
				local ColumnItemHeight = ColumnItem:getHeight()
				
				if ColumnItemHeight > ItemHeight then
					
					ItemHeight = ColumnItemHeight
					
				end
				
			end
			
		end
		
		if HeightOffset > -ItemHeight then
			
			local WidthOffset = 0
			
			for n, Column in pairs(self.Column) do
			
				if Column.Items[i] then
				
					if HeightOffset > Height then
						
						break
						
					end
					
					love.graphics.setScissor(WidthOffset, 0, Column.Width, Height)
					
					Column.Items[i]:Draw(WidthOffset + 5, HeightOffset)
					
					if self.Selected == i then
						
						love.graphics.setColor(0, 0, 0, 70)
						love.graphics.rectangle("fill", WidthOffset, HeightOffset, Column.Width, ItemHeight)
						
					elseif self.IsHover and self.IsHover.y > HeightOffset and self.IsHover.y <= HeightOffset + ItemHeight then
						
						love.graphics.setColor(75, 75, 75, 70)
						love.graphics.rectangle("fill", WidthOffset, HeightOffset, Column.Width, ItemHeight)
						
					end
					
				end
				
				WidthOffset = WidthOffset + Column.Width
				
			end
			
		end
		
		HeightOffset = HeightOffset + ItemHeight
		
	end
	
	love.graphics.setScissor()
	
	local WidthOffset = 0
	local TextHeight = self.Layout.TextFont:getHeight()
	
	for n, Column in pairs(self.Column) do
		
		love.graphics.setColor(self.Layout.BorderColor)
		love.graphics.line(WidthOffset, TextHeight, WidthOffset + Column.Width - 1, TextHeight)
		
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.Layout.Gradient, WidthOffset + 1, 0, 0, Column.Width, TextHeight)
		
		love.graphics.setColor(self.Layout.BorderColor)
		love.graphics.line(WidthOffset + Column.Width, 0, WidthOffset + Column.Width, Height)
		
		love.graphics.setColor(self.Layout.TextColor)
		love.graphics.setFont(self.Layout.TextFont)
		love.graphics.print(Column.Text, WidthOffset + 5, 0)
		
		WidthOffset = WidthOffset + Column.Width
		
	end
	
	love.graphics.setStencilTest()
	
end