local gui = ...
local Element = gui.register("MenuButton", "Container")

Element.Intersect = false

function Element:Create(Text, Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(0, 0)
	self:SetText(Text)
	self:Init()
	
	self.DropDown = gui.create("MenuPanel", self)
	self.DropDown.Hidden = true
	self.SetupCanvas = true
	
	self:UpdateLayout()
	
	return self
end

function Element:CreateOption(Text)
	local MenuButton = gui.create("MenuButton", Text, self.DropDown)
	self.DropDown.Changed = true
	self.DropDown:UpdateLayout()
	self.Changed = true
	return MenuButton
end

function Element:CreateSpacer()
	return gui.create("MenuSpacer", self.DropDown)
end

function Element:MousePressed(...)
	self.DropDown.Hidden = not self.DropDown.Hidden
	self.DropDown.Changed = true
	self.Base.MousePressed(self, ...)
end

function Element:MouseEnter(...)
	self.Parent:IterateHide(self)
	self:SetHover()
	self.DropDown.Hidden = nil
	self.DropDown.Changed = true
	self.Changed = true
	self.Base.MouseEnter(self, ...)
end

function Element:IterateHide()
	for Index, Child in pairs(self.DropDown.Children) do
		if Child.DropDown then
			Child.DropDown.Hidden = true
			Child:IterateHide()
		end
	end
end