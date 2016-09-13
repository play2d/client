local gui = ...
local Element = gui.register("ComboBox", "Element")

Element.HeightOffset = 0
Element.Selected = 0

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}
Element.Up = love.graphics.newImage(gui.Path.."/images/Up-14.png")
Element.Down = love.graphics.newImage(gui.Path.."/images/Down-14.png")

Element.BorderColor = {80, 80, 80, 255}
Element.BackgroundColor = {255, 255, 255, 255}

Element.SelectedColor = {200, 200, 200, 255}
Element.HoverColor = {220, 220, 220, 255}

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	self.Layout.TextFont = Element.TextFont
	self.Layout.TextColor = Element.TextColor
	self.Layout.UpImage = Element.Up
	self.Layout.DownImage = Element.Down
	
	self.Layout.BorderColor = Element.BorderColor
	self.Layout.BackgroundColor = Element.BackgroundColor
	
	self.Layout.SelectedColor = Element.SelectedColor
	self.Layout.HoverColor = Element.HoverColor
	
	self.Item = {}
	
end

function Element:SetItem(Index, Text)
	
	if type(Text) == "string" then
		
		local Skin = self:GetSkin()
		
		self.Item[Index] = gui.CreateText(Text, Skin.TextFont, 80, 80, 80, 255)
		self:UpdateItems()
		
	elseif Text == nil then
		
		self.Item[Index] = nil
		self:UpdateItems()
		
	end
	
	return self
	
end

function Element:UpdateItems()
	
	local HeightOffset = self.HeightOffset
	
	self.HeightOffset = 0
	
	for i, Item in pairs(self.Item) do
		
		self.HeightOffset = self.HeightOffset + Item:getHeight()
		
	end
	
	if HeightOffset ~= self.HeightOffset then
		
		self:UpdateCanvas()
		
	end
	
end

function Element:MousePressed(MouseX, MouseY, Button, IsTouch, ...)
	
	Element.Base.MousePressed(self, MouseX, MouseY, Button, IsTouch, ...)
	
	if Button == 1 and not self.Disabled then
		
		local Width, Height = self.Width, self.Height
		local HeightOffset = Height
		
		for i, Item in pairs(self.Item) do
			
			local ItemHeight = Item:getHeight()
			
			if MouseY > HeightOffset and MouseY <= HeightOffset + ItemHeight then
				
				self:OnSelect(i)
				self.Selected = i
				break
				
			end
			
			HeightOffset = HeightOffset + ItemHeight
			
		end
		
		self.Open = not self.Open
		self:UpdateCanvas()
		self.Parent:AdviseChildDimensions(self, Width, HeightOffset)
		
	end
	
end

function Element:MouseMoved(...)
	
	Element.Base.MouseMoved(self, ...)
	
	self.Changed = true
	
end

function Element:LoseHover(...)
	
	Element.Base.LoseHover(self, ...)
	
	self.Open = nil
	self.Parent:AdviseChildDimensions(self, self.Width, self.Height)
	
end

function Element:UpdateCanvas()
	
	if self.Open then
		
		self.Canvas = love.graphics.newCanvas(self.Width, self.Height + self.HeightOffset)
		
	else
		
		self.Canvas = love.graphics.newCanvas(self.Width, self.Height)
		
	end
	
	self.Changed = true
	
end

function Element:GetHeight()
	
	if self.Open then
		
		return self.Height + self.HeightOffset
		
	end
	
	return self.Height
	
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
	
	self.HeightOffset = 1
	
	for i, Item in pairs(self.Item) do
		
		Item:SetFont(self.Layout.TextFont)
		Item:SetColor(unpack(self.Layout.TextColor))
		
		self.HeightOffset = self.HeightOffset + Item:getHeight()
		
	end
	
end

function Element:RenderSkin()
	
	local Width, Height = self.Width, self.Height
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.rectangle("line", 1, 1, Width - 2, Height - 2)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2)
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.line(Width - 20, 0, Width - 20, Height)
	
	if self.Selected ~= 0 then
		
		local Text = self.Item[self.Selected]
		
		if Text then
			
			Text:Draw(5, (Height - Text:getHeight())/2)
			
		end
		
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	
	if self.Open then
		
		love.graphics.draw(self.Layout.UpImage,
			Width - (self.Layout.UpImage:getWidth() + 20)/2,
			(Height - self.Layout.UpImage:getHeight())/2
		)
		
		love.graphics.setColor(self.Layout.BorderColor)
		love.graphics.rectangle("line", 1, Height, Width - 2, self.HeightOffset - 1)
		
		love.graphics.setColor(self.Layout.BackgroundColor)
		love.graphics.rectangle("fill", 1, Height, Width - 2, self.HeightOffset - 1)
		
		local HeightOffset = Height
		
		for i, Item in pairs(self.Item) do
			
			local ItemHeight = Item:getHeight()
			
			if HeightOffset > -ItemHeight then
				
				if self.Selected == i then
					
					love.graphics.setColor(self.Layout.SelectedColor)
					love.graphics.rectangle("fill", 1, HeightOffset, Width - 2, ItemHeight)
					
				elseif self.IsHover and self.IsHover.y > HeightOffset and self.IsHover.y <= HeightOffset + ItemHeight then
					
					love.graphics.setColor(self.Layout.HoverColor)
					love.graphics.rectangle("fill", 1, HeightOffset, Width - 2, ItemHeight)
					
				end
				
				Item:Draw(5, HeightOffset)
				
			end
			
			HeightOffset = HeightOffset + ItemHeight
			
		end
		
	else
		
		love.graphics.draw(self.Layout.DownImage,
			Width - (self.Layout.DownImage:getWidth() + 20)/2,
			(Height - self.Layout.DownImage:getHeight())/2
		)
		
	end
	
end