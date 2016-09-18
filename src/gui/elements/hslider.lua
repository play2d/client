local gui = ...
local Element = gui.register("HSlider", "Container")
local Button = gui.get("Button")

Element.Left = love.graphics.newImage(gui.Path.."/images/Left-14.png")
Element.Right = love.graphics.newImage(gui.Path.."/images/Right-14.png")

Element.BorderColor = {80, 80, 80, 255}
Element.BackgroundColor = {200, 200, 200, 255}

Element.ArcRadius = 5

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
		
		local Width = Slider:GetWidth()
		local Max = math.max(Width - (Width -  30) * Slider.Min / Slider.Max - 30, 1)
		local Position = math.min(math.max(self:GetHorizontalPosition() + dx, 15), Max + 15)
		
		self:SetHorizontalPosition(math.floor(Position))
		Slider.Value = (Position - 15) / Max * Slider.Max
		Slider:OnValue(Slider.Value)
		
	end
	
	Button.Base.MouseDrag(self, x, y, dx, dy, ...)
	
end

local function ButtonLeft(self, ...)
	
	if self.IsPressed then
		
		local Slider = self.Parent
		
		if not Slider.Disabled then
			
			local Button = Slider.Layout.Button
			local Width = Slider:GetWidth()
			local Max = math.max(Width - (Width -  30) * Slider.Min / Slider.Max - 30, 1)
			local Position = math.min(math.max(Slider.Layout.Button:GetHorizontalPosition() - love.timer.getDelta() * 200, 15), Max + 15)
			
			Slider.Layout.Button:SetHorizontalPosition( Position )
			Slider.Value = (Position - 15) / Max * Slider.Max
			Slider:OnValue(Slider.Value)
			
		end
		
	end
	
	Button.Base.Update(self, ...)
end

local function ButtonRight(self, ...)
	
	if self.IsPressed then
		
		local Slider = self.Parent
		
		if not Slider.Disabled then
			
			local Button = Slider.Layout.Button
			local Width = Slider:GetWidth()
			local Max = math.max(Width - (Width -  30) * Slider.Min / Slider.Max - 30, 1)
			local Position = math.min(math.max(Slider.Layout.Button:GetHorizontalPosition() + love.timer.getDelta() * 200, 15), Max + 15)
			
			Slider.Layout.Button:SetHorizontalPosition( Position )
			Slider.Value = (Position - 15) / Max * Slider.Max
			Slider:OnValue(Slider.Value)
			
		end
		
	end
	
	Button.Base.Update(self, ...)
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	local Width, Height = self:GetDimensions()
	
	self.Layout.BorderColor = Element.BorderColor
	self.Layout.BackgroundColor = Element.BackgroundColor
	
	self.Layout.ArcRadius = Element.ArcRadius
	
	self.Layout.Left = gui.create("Button", "", 0, 0, 16, Height, self)
	self.Layout.Left.Layout.Rounded = true
	self.Layout.Left.Layout.ArcRadius = self.Layout.ArcRadius
	self.Layout.Left:SetIcon(Element.Left)
	self.Layout.Left.Update = ButtonLeft
	
	self.Layout.Right = gui.create("Button", "", 0, 0, 16, Height, self)
	self.Layout.Right.Layout.Rounded = true
	self.Layout.Right.Layout.ArcRadius = self.Layout.ArcRadius
	self.Layout.Right:SetIcon(Element.Right)
	self.Layout.Right.Update = ButtonRight
	
	self.Layout.Button = gui.create("Button", "", 15, 0, Width - 30, Height, self)
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
	
	self.Layout.Button:SetHorizontalPosition(15 + Value * (self:GetWidth() - 30 - self.Layout.Button:GetWidth()) / self.Max)
	self.Value = Value
	
end

function Element:GetValue()
	
	return self.Value
	
end

function Element:OnValue(Value)
	
end

function Element:UpdateLayout()
	
	local Width, Height = self:GetDimensions()
	
	self.Layout.Left:SetDimensions(16, Height)
	self.Layout.Right:SetDimensions(16, Height)
	self.Layout.Right:SetPosition(Width - 16, 0)
	self.Layout.Button:SetDimensions(math.floor( (Width - 30) * self.Min / self.Max), Height)
	
	local ArcRadius = self.Layout.ArcRadius
	
	self.Layout.Left.Layout.ArcRadius = ArcRadius
	self.Layout.Right.Layout.ArcRadius = ArcRadius
	self.Layout.Button.Layout.ArcRadius = ArcRadius
	
	local LineWidth = self.Layout.LineWidth
	
	self.Layout.Left.Layout.LineWidth = LineWidth
	self.Layout.Right.Layout.LineWidth = LineWidth
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