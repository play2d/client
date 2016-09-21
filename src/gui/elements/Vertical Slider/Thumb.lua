local gui = ...
local Element = gui.register("VSliderThumb", "Button")

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

function Element:MouseDrag(x, y, dx, dy, ...)
	
	local Slider = self.Parent
	
	if not Slider.Disabled then
		
		local Height = Slider:GetHeight()
		local Max = math.max(Height - (Height -  30) * Slider.Min / Slider.Max - 30, 1)
		local Position = math.min(math.max(self:GetVerticalPosition() + dy, 15), Max + 15)
		
		self:SetVerticalPosition( Position )
		Slider.Value = (Position - 15) / Max * Slider.Max
		Slider:OnValue(Slider.Value)
		
	end
	
	Element.Base.MouseDrag(self, x, y, dx, dy, ...)
	
end