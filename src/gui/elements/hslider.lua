local gui = ...
local Element = gui.register("HSlider", "Container")

-- NOTE THAT MOST OF THE IMPORTANT CODE OF THIS ELEMENT IS STORED ON THE SKIN SCRIPT
function Element:Create(x, y, Width, Height, Parent)
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
end

function Element:Init()
	self.Max = 1
	self.Min = 1
	self.Value = 0
	self.Base.Init(self)
end

function Element:SetMax(Max)
	if Max ~= self.Max then
		local Max = math.max(Max, self.Min, 1)
		if Max ~= self.Max then
			self.Max = Max
			self.Changed = true
		end
	end
	return self
end

function Element:SetMin(Min)
	if Min ~= self.Min then
		local Min = math.max(Min, 1)
		local Max = math.max(self.Max, self.Min)
		if Min ~= self.Min or Max ~= self.Max then
			self.Min = Min
			self.Max = Max
			self.Changed = true
		end
	end
	return self
end

function Element:SetValue(Value)
	local Value = math.min(math.max(Value or 0, 0), self.Max)
	local Skin = self:GetSkin()
	if Skin.UpdateValue then
		Skin.UpdateValue(self, Value)
	end
	self.Value = Value
end

function Element:GetValue()
	return self.Value
end

function Element:OnValue(Value)
end