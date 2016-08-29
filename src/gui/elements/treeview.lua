local gui = ...
local Element = gui.register("TreeView", "Container")

function Element:Create(x, y, Width, Height, Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
end

function Element:AddNode(Name, Icon)
	return gui.create("TreeViewNode", Name, 0, 0, self)
end

function Element:RenderChildren(x, y)
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