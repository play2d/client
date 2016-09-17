local gui = ...
local Element = gui.register("ProgressBar", "Element")

Element.Progress = 0

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

function Element:SetProgress(Progress)
	
	self.Progress = tonumber(Progress)
	self.Changed = true
	return self
	
end

function Element:GetProgress()
	
	return self.Progress
	
end