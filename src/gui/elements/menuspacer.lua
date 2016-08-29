local gui = ...
local Element = gui.register("MenuSpacer", "Element")

function Element:Create(Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(0, 0)
	self:Init()
	
	return self
end