local gui = ...
local Element = gui.register("Button", "Element")

function Element:Create(Text, x, y, Width, Height, Parent)
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetText(Text)
	self:Init()
	
	return self
end

function Element:SetIcon(Image)
	self.Image = Image
	self.Changed = true
end