local gui = ...
local Element = gui.register("Tabber", "Container")

Element.Left = love.graphics.newImage(gui.Path.."/images/Left-14.png")
Element.Right = love.graphics.newImage(gui.Path.."/images/Right-14.png")

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}

Element.BorderColor = {80, 80, 80, 255}
Element.SelectedColor = {255, 255, 255, 255}

Element.HoverColor = {255, 255, 255, 255}
Element.DefaultColor = {220, 220, 220, 255}

Element.Gradient = love.graphics.newMesh(
	{
		{
			0, 0,
			0, 0,
			255, 255, 255
		},
		{
			1, 0,
			1, 0,
			255, 255, 255
		},
		{
			1, 1,
			1, 1,
			208, 208, 208
		},
		{
			0, 1,
			0, 1,
			208, 208, 208
		}
	}
, "fan", "static")

Element.Selected = 0

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

local function TabberButtonL(self)
	
	if self.IsPressed then
		
		self.Parent.Layout.Offset = math.max(self.Parent.Layout.Offset - 3, 0)
		self.Parent.Changed = true
		
	end
	
end

local function TabberButtonR(self)
	
	if self.IsPressed then
		
		self.Parent.Layout.Offset = math.min(self.Parent.Layout.Offset + 3, self.Parent.Layout.ItemsWidth - self.Parent:GetWidth())
		self.Parent.Changed = true
		
	end
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	local Width, Height = self:GetDimensions()

	self.Layout.TextFont = Element.TextFont
	self.Layout.TextColor = Element.TextColor
	
	self.Layout.BorderColor = Element.BorderColor
	self.Layout.SelectedColor = Element.SelectedColor
	
	self.Layout.HoverColor = Element.HoverColor
	self.Layout.DefaultColor = Element.DefaultColor
	
	self.Layout.Offset = 0
	self.Layout.ItemsWidth = 0
	
	self.Layout.Left = gui.create("Button", "", 0, 2, 12, Height - 2.5, self)
	self.Layout.Left:SetIcon(Element.Left)
	self.Layout.Left.Update = TabberButtonL
	
	self.Layout.Right = gui.create("Button", "", 0, 2, 12, Height - 2.5, self)
	self.Layout.Right:SetIcon(Element.Right)
	self.Layout.Right.Update = TabberButtonR
	
	self.Layout.Gradient = Element.Gradient
	
	self.Item = {}
	
end

function Element:MouseMoved(...)
	
	self.Changed = true
	
	Element.Base.MouseMoved(self, ...)
	
end

function Element:MouseExit(...)
	
	self.Changed = true
	
	Element.Base.MouseExit(self, ...)
	
end

function Element:MousePressed(MouseX, MouseY, Button, IsTouch, ...)
	
	if Button == 1 and not self.Disabled then
		
		local WidthOffset = -self.Layout.Offset + 1
		
		for i, Item in pairs(self.Item) do
			
			local ItemWidth = Item:getWidth()
			
			if WidthOffset > -ItemWidth and self.IsHover and self.IsHover.x > WidthOffset and self.IsHover.x <= WidthOffset + ItemWidth + 10 then
				
				self:OnSelect(i)
				self.Selected = i
				self.Changed = true
				break
				
			end
			
			WidthOffset = WidthOffset + ItemWidth + 10
			
		end
		
	end
	
	Element.Base.MousePressed(self, MouseX, MouseY, Button, IsTouch, ...)
	
end

function Element:SetItem(Index, Text)
	
	if type(Text) == "string" or getmetatable(Text).__tostring then
		
		self.Item[Index] = gui.CreateText(Text, self.Layout.TextFont, 80, 80, 80, 255)
		self:UpdateItems()
		
	elseif Text == nil then
		
		self.Item[Index] = nil
		self:UpdateItems()
		
	end
	
	return self
end

function Element:UpdateItems()
	
	table.sort(self.Item)
	
	self.Layout.ItemsWidth = 1
	self.Changed = true
	
	for Index, Item in pairs(self.Item) do
		
		self.Layout.ItemsWidth = self.Layout.ItemsWidth + Item:getWidth() + 10
		
	end
	
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

function Element:UpdateLayout()
	
	local Width, Height = self:GetDimensions()
	
	for i, Item in pairs(self.Item) do
		
		Item:SetFont(self.Layout.TextFont)
		Item:SetColor(unpack(self.Layout.TextColor))
		
	end
	
	self.Layout.Left:SetDimensions(12, Height - 2)
	self.Layout.Left:SetPosition(0, 2)
	self.Layout.Left.Hidden = self.Layout.Offset == 0
	
	self.Layout.Right:SetDimensions(12, Height - 2)
	self.Layout.Right:SetPosition(Width -  12, 2)
	self.Layout.Right.Hidden = self.Layout.Offset >= self.Layout.ItemsWidth - Width
	
end

function Element:RenderSkin()
	local Width, Height = self:GetDimensions()
	
	local WidthOffset = -self.Layout.Offset + 1
	
	for i, Item in pairs(self.Item) do
		
		local ItemWidth = Item:getWidth()
		
		if WidthOffset > -ItemWidth then
			
			if WidthOffset > Width then
				
				break
				
			end
			
			if self.Selected == i then
				
				love.graphics.setColor(self.Layout.BorderColor)
				love.graphics.rectangle("line", WidthOffset, 1, ItemWidth + 9, Height - 2)
				
				love.graphics.setColor(self.Layout.SelectedColor)
				love.graphics.rectangle("fill", WidthOffset, 1, ItemWidth + 9, Height - 2)
				
				Item:Draw(WidthOffset + 2, (Height - Item:getHeight())/2)
				
			elseif self.IsHover and self.IsHover.x > WidthOffset and self.IsHover.x <= WidthOffset + ItemWidth + 10 then
				
				love.graphics.setColor(self.Layout.BorderColor)
				love.graphics.rectangle("line", WidthOffset, 3, ItemWidth + 9, Height - 4)
				
				love.graphics.setColor(self.Layout.HoverColor)
				love.graphics.draw(self.Layout.Gradient, WidthOffset, 3, 0, ItemWidth + 9, Height - 4)
				
				Item:Draw(WidthOffset + 2, (Height + 2 - Item:getHeight())/2)
				
			else
				
				love.graphics.setColor(self.Layout.BorderColor)
				love.graphics.rectangle("line", WidthOffset, 3, ItemWidth + 9, Height - 4)
				
				love.graphics.setColor(self.Layout.DefaultColor)
				love.graphics.draw(self.Layout.Gradient, WidthOffset, 3, 0, ItemWidth + 9, Height - 4)
				
				Item:Draw(WidthOffset + 2, (Height + 2 - Item:getHeight())/2)
				
			end
			
		end
		
		WidthOffset = WidthOffset + ItemWidth + 10
		
	end
	
end