local Path, gui = ...
local CollapsibleNode = {}

CollapsibleNode.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
CollapsibleNode.TextColor = {80, 80, 80, 255}

CollapsibleNode.Color = {255, 255, 255, 255}
CollapsibleNode.ColorHover = {240, 240, 240, 255}
CollapsibleNode.ColorPressed = {220, 220, 220, 255}

CollapsibleNode.BorderColor = {130, 130, 130, 255}
CollapsibleNode.BackgroundColor = {200, 200, 200, 255}

CollapsibleNode.ImageColor = {255, 255, 255, 255}

function CollapsibleNode:Init()
	self.Layout.TextFont = CollapsibleNode.TextFont
	self.Layout.TextColor = CollapsibleNode.TextColor
	
	self.Layout.Color = CollapsibleNode.Color
	self.Layout.ColorHover = CollapsibleNode.ColorHover
	self.Layout.ColorPressed = CollapsibleNode.ColorPressed
	
	self.Layout.BorderColor = CollapsibleNode.BorderColor
	self.Layout.BackgroundColor = CollapsibleNode.BackgroundColor
	
	self.Layout.ImageColor = CollapsibleNode.ImageColor
	
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
end

function CollapsibleNode:UpdateLayout()
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
end

function CollapsibleNode:MouseEnter()
	self.Changed = true
end

function CollapsibleNode:MouseExit()
	self.Changed = true
end

function CollapsibleNode:MouseMoved(x, y, dx, dy)
	if (y - dy <= self.Parent.NodeHeight and y > self.Parent.NodeHeight) or (y - dy > self.Parent.NodeHeight and y <= self.Parent.NodeHeight) then
		self.Changed = true
	end
end

function CollapsibleNode:MousePressed()
	self.Changed = true
end

function CollapsibleNode:MouseReleased()
	self.Changed = true
end

function CollapsibleNode:Render()
	local Width, Height, Radius = self:GetWidth(), self.Parent.NodeHeight, self.Radius
	CollapsibleNode.Width, CollapsibleNode.Height, CollapsibleNode.Radius = Width, Height, Radius
	
	if self.Open then
		love.graphics.setColor(self.Layout.BorderColor)
		gui.graphics.roundedbox("line", self.Radius, 1, Height, Width - 2, self:GetHeight() - Height - 1)
		
		love.graphics.setColor(self.Layout.BackgroundColor)
		gui.graphics.roundedbox("fill", self.Radius, 1, Height, Width - 2, self:GetHeight() - Height - 1)
	end
	
	love.graphics.setColor(self.Layout.BorderColor)
	gui.graphics.roundedbox("line", self.Radius, 1, 1, Width - 2, Height - 2)
	
	if self.IsPressed then
		love.graphics.setColor(self.Layout.ColorPressed)
		gui.graphics.roundedbox("fill", Radius, 1, 1, Width - 2, Height - 2)
		
		if self.Image then
			love.graphics.setColor(self.Layout.ImageColor)
			love.graphics.draw(self.Image,
				math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2),
				math.floor((Height - self.Image:getHeight())/2)
			)
		end
		
		self.Text:Draw(math.floor((Width - self.Text:getWidth())/2), math.floor((Height - self.Text:getHeight())/2))
	elseif self.IsHover and self.IsHover.y <= Height then
		love.graphics.setColor(self.Layout.ColorHover)
		gui.graphics.roundedbox("fill", Radius, 1, 1, Width - 2, Height - 2)
		
		if self.Image then
			love.graphics.setColor(self.Layout.ImageColor)
			love.graphics.draw(self.Image,
				math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2),
				math.floor((Height - self.Image:getHeight())/2)
			)
		end
		
		self.Text:Draw(math.floor((Width - self.Text:getWidth())/2), math.floor((Height - self.Text:getHeight())/2) - 1)
	else
		love.graphics.setColor(self.Layout.Color)
		gui.graphics.roundedbox("fill", Radius, 1, 1, Width - 2, Height - 2)

		if self.Image then
			love.graphics.setColor(self.Layout.ImageColor)
			love.graphics.draw(self.Image,
				math.floor((Width - self.Image:getWidth() - self.Text:getWidth())/2),
				math.floor((Height - self.Image:getHeight())/2)
			)
		end
		
		self.Text:Draw((Width - self.Text:getWidth())/2, (Height - self.Text:getHeight())/2 - 1)
	end
end

return CollapsibleNode