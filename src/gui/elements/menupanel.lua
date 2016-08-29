local gui = ...
local Element = gui.register("MenuPanel", "Container")

Element.Intersect = false

function Element:Create(Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(0, 0)
	self:Init()
	
	self.SetupCanvas = true
	self:UpdateLayout()
	
	return self
end

function Element:IterateHide()
	for Index, Child in pairs(self.Children) do
		if Child.DropDown then
			Child.DropDown.Hidden = true
			Child:IterateHide()
		end
	end
end