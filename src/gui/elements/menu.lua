local gui = ...
local Element = gui.register("Menu", "Container")

Element.Intersect = false

function Element:Create(Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(0, 0)
	self:Init()
	self.SetupCanvas = true
	
	return self
end

function Element:CreateOption(Text)
	return gui.create("MenuButton", Text, self)
end

function Element:IterateHide(Exclude)
	for Index, Child in pairs(self.Children) do
		if Child ~= Exclude then
			Child.DropDown.Hidden = true
			Child:IterateHide()
		end
	end
end

function Element:ParentMousePressed()
	self:IterateHide()
end