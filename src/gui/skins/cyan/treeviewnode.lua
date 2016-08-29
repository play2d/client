local Path, gui = ...
local TreeViewNode = {}

TreeViewNode.Plus = love.graphics.newImage(Path.."/Plus 2 Math-14.png")
TreeViewNode.Minus = love.graphics.newImage(Path.."/Minus 2 Math-14.png")

function TreeViewNode:Init()
	self.Layout.TextFont = self.Parent.Layout.TextFont
	self.Layout.TextColor = self.Parent.Layout.TextColor
	self.Layout.HeightOffset = self.Text:getHeight()
	
	self.Layout.Color = TreeViewNode.Color
	self.Layout.ColorHover = TreeViewNode.ColorHover
	
	self.Layout.PlusImage = TreeViewNode.Plus
	self.Layout.MinusImage = TreeViewNode.Minus
	
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
end

function TreeViewNode:UpdateLayout()
	self.Layout.HeightOffset = self.Text:getHeight() + 2
	for Index, Child in pairs(self.ChildrenRender) do
		Child.x = 10
		Child.y = self.Layout.HeightOffset
		
		self.Layout.HeightOffset = self.Layout.HeightOffset + Child:GetHeight() + 2
	end
	
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.Text:SetFont(self.Layout.TextFont)
end

function TreeViewNode:Render()
	local Width, Height = self:GetDimensions()
	
	if self.Open then
		love.graphics.draw(self.Layout.PlusImage, 0, math.floor((self.Text:getHeight() - self.Layout.PlusImage:getHeight())/2))
		love.graphics.setColor(self.Layout.TextColor)
		love.graphics.setFont(self.Layout.TextFont)
		self.Text:Draw(self.Layout.PlusImage:getWidth() + 2, 0)
	else
		love.graphics.draw(self.Layout.MinusImage, 0, math.floor((self.Text:getHeight() - self.Layout.MinusImage:getHeight())/2))
		love.graphics.setColor(self.Layout.TextColor)
		love.graphics.setFont(self.Layout.TextFont)
		self.Text:Draw(self.Layout.MinusImage:getWidth() + 2, 0)
	end
end

function TreeViewNode:MousePressed()
	self.Open = not self.Open
	self.Changed = true
	self.Parent.Changed = true
end

function TreeViewNode:MouseEnter()
	self.Changed = true
end

function TreeViewNode:MouseExit()
	self.Changed = true
end

return TreeViewNode