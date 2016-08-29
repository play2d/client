local gui = ...
local Element = assert(gui.register("Console", "Container"))

function Element:Create(x, y, Width, Height, Parent)
	Parent = Parent or gui.Desktop
	
	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetText(Text)
	self:Init()
	
	return self
end

function Element:Print(Text)
end