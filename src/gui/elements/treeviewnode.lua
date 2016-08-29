local gui = ...
local Element = gui.register("TreeViewNode", "Container")

function Element:Create(Text, x, y, Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetText(Text)
	self:Init()
	
	return self
end

function Element:AddNode(Name, Icon)
	return gui.create("TreeViewNode", Name, 0, 0, self)
end

function Element:GetWidth()
	return self.Text:getWidth() + 20
end

function Element:GetHeight()
	if self.Open then
		return self.Layout.HeightOffset
	end
	return self.Text:getHeight()
end

-- This shouldn't be able to be on top
function Element:SetHover()
	if self.Parent then
		self.Parent:SetHover()
	end
end

function Element:RenderChildren(x, y)
	if self.Open then
		for _, Child in pairs(self.ChildrenRender) do
			if not Child.Hidden then
				local Horizontal, Vertical = Child:GetPosition()
				local ChildX, ChildY = Horizontal + x, Vertical + y

				Child:Render(ChildX, ChildY)
				if Child.RenderChildren then
					Child:RenderChildren(ChildX, ChildY, IntersectX, IntersectY, IntersectWi)
				end
			end
		end
	end
end