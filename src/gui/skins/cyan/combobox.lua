local Path, gui = ...
local ComboBox = {}

ComboBox.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
ComboBox.TextColor = {80, 80, 80, 255}
ComboBox.Up = love.graphics.newImage(Path.."/Up-14.png")
ComboBox.Down = love.graphics.newImage(Path.."/Down-14.png")

ComboBox.BorderColor = {80, 80, 80, 255}
ComboBox.BackgroundColor = {255, 255, 255, 255}

ComboBox.SelectedColor = {80, 80, 80, 255}
ComboBox.HoverColor = {75, 75, 75, 255}

function ComboBox:Init()
	self.Layout.TextFont = ComboBox.TextFont
	self.Layout.TextColor = ComboBox.TextColor
	self.Layout.UpImage = ComboBox.Up
	self.Layout.DownImage = ComboBox.Down
	
	self.Layout.BorderColor = ComboBox.BorderColor
	self.Layout.BackgroundColor = ComboBox.BackgroundColor
	
	self.Layout.SelectedColor = ComboBox.SelectedColor
	self.Layout.HoverColor = ComboBox.HoverColor
end

function ComboBox:UpdateLayout()
	for i, Item in pairs(self.Item) do
		Item:SetFont(self.Layout.TextFont)
		Item:SetColor(unpack(self.Layout.TextColor))
	end
end

function ComboBox:MouseMoved()
	self.Changed = true
end

function ComboBox:MousePressed(MouseX, MouseY, Button, IsTouch)
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

function ComboBox:UpdateItems()
	self.HeightOffset = 0
	for i, Item in pairs(self.Item) do
		self.HeightOffset = self.HeightOffset + Item:getHeight()
	end
	self.Changed = true
end

function ComboBox:Render()
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
				Item:Draw(5, HeightOffset)
				
				if self.Selected == i then
					love.graphics.setColor(self.Layout.SelectedColor)
					love.graphics.rectangle("fill", 0, HeightOffset, Width, ItemHeight)
				elseif self.IsHover and self.IsHover.y > HeightOffset and self.IsHover.y <= HeightOffset + ItemHeight then
					love.graphics.setColor(self.Layout.HoverColor)
					love.graphics.rectangle("fill", 0, HeightOffset, Width, ItemHeight)
				end
			end
			
			HeightOffset = HeightOffset + ItemHeight
		end
		love.graphics.setStencilTest()
	else
		love.graphics.draw(self.Layout.DownImage,
			Width - (self.Layout.DownImage:getWidth() + 20)/2,
			(Height - self.Layout.DownImage:getHeight())/2
		)
	end
end

return ComboBox