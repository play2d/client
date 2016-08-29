local gui = ...
local Element = gui.register("CollapsibleCategory", "Container")

Element.NodeHeight = 20

function Element:Create(x, y, Width, Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width)
	self:Init()

	return self
end

function Element:SetOpenAll(Open)
	for Index, CollapsibleNode in pairs(self.Children) do
		CollapsibleNode.Open = Open
	end
end

function Element:AddCategory(Name, Radius)
	return gui.create("CollapsibleNode", Name, Radius or 4, self)
end

function Element:AdviseChildDimensions(Child, Width, Height)
	self.Parent:AdviseChildDimensions(self, self:GetWidth(), self:GetHeight())
	self:UpdateLayout()
end

function Element:SetNodeHeight(Height)
	self.NodeHeight = Height
end

function Element:GetNodeHeight()
	return self.NodeHeight
end

function Element:GetHeight()
	if self.LastChild then
		return self.LastChild:GetVerticalPosition() + self.LastChild:GetHeight()
	end
	return 0
end

function Element:Render()
end