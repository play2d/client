local gui = ...
local Element = gui.register("CheckBox", "Element")

function Element:Create(Text, x, y, Width, Height, Parent)
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetText(Text)
	self:Init()
	
	return self
end

function Element:IsChecked()
	return self.Status ~= nil
end

function Element:SetChecked(Checked)
	if Checked then
		self.Status = true
	else
		self.Status = nil
	end
	self.Changed = true
end
	