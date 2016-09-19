local gui = ...
local Element = gui.register("VSlider", "Container")
local Button = gui.get("Button")

Element.Up = love.graphics.newImage(gui.Path.."/images/Up-14.png")
Element.Down = love.graphics.newImage(gui.Path.."/images/Down-14.png")

Element.BorderColor = {80, 80, 80, 255}
Element.BackgroundColor = {200, 200, 200, 255}

Element.ArcRadius = 6

Element.Max = 1
Element.Min = 1
Element.Value = 0

Element.LineWidth = 1

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

local function ButtonDrag(self, x, y, dx, dy, ...)
	
	local Slider = self.Parent
	
	if not Slider.Disabled then
		
		local Height = Slider:GetHeight()
		local Max = math.max(Height - (Height -  30) * Slider.Min / Slider.Max - 30, 1)
		local Position = math.min(math.max(self:GetVerticalPosition() + dy, 15), Max + 15)
		
		self:SetVerticalPosition(math.floor(Position))
		Slider.Value = (Position - 15) / Max * Slider.Max
		Slider:OnValue(Slider.Value)
		
	end
	
	Button.Base.MouseDrag(self, x, y, dx, dy, ...)
	
end

local function ButtonUP(self, ...)
	
	if self.IsPressed then
		
		local Slider = self.Parent
		
		if not Slider.Disabled then
			
			local Button = Slider.Layout.Button
			local Height = Slider:GetHeight()
			local Max = math.max(Height - (Height -  30) * Slider.Min / Slider.Max - 30, 1)
			local Position = math.min(math.max(Button:GetVerticalPosition() - love.timer.getDelta() * 200, 15), Max + 15)
			
			Button:SetVerticalPosition( Position )
			Slider.Value = (Position - 15) / Max * Slider.Max
			Slider:OnValue(Slider.Value)
			
		end
		
	end
	
	Button.Base.Update(self, ...)
	
end

local function ButtonDown(self, ...)
	
	if self.IsPressed then
		
		local Slider = self.Parent
		
		if not Slider.Disabled then
			
			local Button = Slider.Layout.Button
			local Height = Slider:GetHeight()
			local Max = math.max(Height - (Height -  30) * Slider.Min / Slider.Max - 30, 1)
			local Position = math.min(math.max(Button:GetVerticalPosition() + love.timer.getDelta() * 200, 15), Max + 15)
			
			Button:SetVerticalPosition( Position )
			Slider.Value = (Position - 15) / Max * Slider.Max
			Slider:OnValue(Slider.Value)
			
		end
		
	end
	
	Element.Base.Update(self, ...)
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	local Width, Height = self:GetDimensions()
	
	self.Layout.BorderColor = Element.BorderColor
	self.Layout.BackgroundColor = Element.BackgroundColor
	
	self.Layout.ArcRadius = Element.ArcRadius
	
	self.Layout.Up = gui.create("Button", "", 0, 0, Width, 15, self)
	self.Layout.Up.Layout.Rounded = true
	self.Layout.Up.Layout.ArcRadius = self.Layout.ArcRadius
	self.Layout.Up:SetIcon(Element.Up)
	self.Layout.Up.Update = ButtonUP
	
	self.Layout.Down = gui.create("Button", "", 0, 0, Width, 15, self)
	self.Layout.Down.Layout.Rounded = true
	self.Layout.Down.Layout.ArcRadius = self.Layout.ArcRadius
	self.Layout.Down:SetIcon(Element.Down)
	self.Layout.Down.Update = ButtonDown
	
	self.Layout.Button = gui.create("Button", "", 0, 15, Width, Height - 30, self)
	self.Layout.Button.Layout.Rounded = true
	self.Layout.Button.Layout.ArcRadius = self.Layout.ArcRadius
	self.Layout.Button.MouseDrag = ButtonDrag
	
	self.Layout.LineWidth = Element.LineWidth
	
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
	
	self.Layout.Button:SetVerticalPosition(15 + Value * (self:GetHeight() - 30 - self.Layout.Button:GetHeight()) / self.Max)
	self.Value = Value
	
end

function Element:GetValue()
	
	return self.Value
	
end

function Element:OnValue(Value)
	
end

function Element:UpdateLayout()
	
	local Width, Height = self:GetDimensions()
	
	self.Layout.Up:SetDimensions(Width, 15)
	self.Layout.Down:SetDimensions(Width, 15)
	self.Layout.Down:SetPosition(0, Height - 15)
	self.Layout.Button:SetDimensions(Width, math.floor((Height - 30) * self.Min / self.Max))
	
	local ArcRadius = self.Layout.ArcRadius
	
	self.Layout.Up.Layout.ArcRadius = ArcRadius
	self.Layout.Down.Layout.ArcRadius = ArcRadius
	self.Layout.Button.Layout.ArcRadius = ArcRadius
	
	local LineWidth = self.Layout.LineWidth
	
	self.Layout.Up.Layout.LineWidth = LineWidth
	self.Layout.Down.Layout.LineWidth = LineWidth
	self.Layout.Button.Layout.LineWidth = LineWidth
	
end

function Element:RenderSkin(dt)
	
	love.graphics.setLineWidth(self.Layout.LineWidth)
	
	local Width, Height = self:GetDimensions()
	local Radius = self.Layout.ArcRadius
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.rectangle("line", 0, 0, Width, Height, Radius, Radius, Radius)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2, Radius, Radius, Radius)
	
end