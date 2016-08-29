local Path, gui = ...
local Tabber = {}

Tabber.Left = love.graphics.newImage(Path.."/Left-14.png")
Tabber.Right = love.graphics.newImage(Path.."/Right-14.png")

Tabber.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Tabber.TextColor = {80, 80, 80, 255}

Tabber.BorderColor = {80, 80, 80, 255}
Tabber.SelectedColor = {255, 255, 255, 255}
Tabber.HoverColor = {255, 255, 255, 255}
Tabber.DefaultColor = {220, 220, 220, 255}

Tabber.Image = love.image.newImageData(1, 20)
for y = 0, 19 do
	Tabber.Image:setPixel(0, y, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19, 255 * 9/11 + 255 * (19 - y) * 2/11 * 1/19)
end
Tabber.Image = love.graphics.newImage(Tabber.Image)

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

function Tabber:MouseMoved()
	self.Changed = true
end

function Tabber:MouseExit()
	self.Changed = true
end

function Tabber:MousePressed(MouseX, MouseY, Button, IsTouch)
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
end

function Tabber:Init()
	local Width, Height = self:GetDimensions()
	
	self.Layout.TextFont = Tabber.TextFont
	self.Layout.TextColor = Tabber.TextColor
	
	self.Layout.BorderColor = Tabber.BorderColor
	self.Layout.SelectedColor = Tabber.SelectedColor
	self.Layout.HoverColor = Tabber.HoverColor
	self.Layout.DefaultColor = Tabber.DefaultColor
	
	self.Layout.Offset = 0
	self.Layout.ItemsWidth = 0
	
	self.Layout.Left = gui.create("Button", "", 0, 2, 12, Height - 2.5, self)
	self.Layout.Left:SetIcon(Tabber.Left)
	self.Layout.Left.Update = TabberButtonL
	
	self.Layout.Right = gui.create("Button", "", 0, 2, 12, Height - 2.5, self)
	self.Layout.Right:SetIcon(Tabber.Right)
	self.Layout.Right.Update = TabberButtonR
end

function Tabber:UpdateItems()
	self.Layout.ItemsWidth = 1
	for Index, Item in pairs(self.Item) do
		self.Layout.ItemsWidth = self.Layout.ItemsWidth + Item:getWidth() + 10
	end
	self.Changed = true
end

function Tabber:UpdateLayout()
	local Width, Height = self:GetDimensions()
	
	for i, Item in pairs(self.Item) do
		self.Item:SetFont(self.Layout.TextFont)
		self.Item:SetColor(unpack(self.Layout.TextColor))
	end
	
	self.Layout.Left:SetDimensions(12, Height - 2)
	self.Layout.Left:SetPosition(0, 2)
	self.Layout.Left.Hidden = self.Layout.Offset == 0
	
	self.Layout.Right:SetDimensions(12, Height - 2)
	self.Layout.Right:SetPosition(Width -  12, 2)
	self.Layout.Right.Hidden = self.Layout.Offset >= self.Layout.ItemsWidth - Width
end

function Tabber:Render()
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
				love.graphics.draw(Tabber.Image, WidthOffset, 3, 0, ItemWidth + 9, (Height - 4)/20)
				Item:Draw(WidthOffset + 2, (Height + 2 - Item:getHeight())/2)
			else
				love.graphics.setColor(self.Layout.BorderColor)
				love.graphics.rectangle("line", WidthOffset, 3, ItemWidth + 9, Height - 4)
				
				love.graphics.setColor(self.Layout.DefaultColor)
				love.graphics.draw(Tabber.Image, WidthOffset, 3, 0, ItemWidth + 9, (Height - 4)/20)
				Item:Draw(WidthOffset + 2, (Height + 2 - Item:getHeight())/2)
			end
		end
		
		WidthOffset = WidthOffset + ItemWidth + 10
	end
end

return Tabber