local gui = ...
local Element = gui.register("HSlider", "Container")

Element.Left = love.graphics.newImage(gui.Path.."/Images/Left-14.png")
Element.Right = love.graphics.newImage(gui.Path.."/Images/Right-14.png")

Element.BorderColor = {80, 80, 80, 255}
Element.BackgroundColor = {200, 200, 200, 255}

Element.Max = 1
Element.Min = 1
Element.Value = 0

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

local function SliderButtonDrag(Button, x, y, dx, dy)
	
	local Slider = Button.Parent
	
	if not Slider.Disabled then
		
		local Width = Slider:GetWidth()
		local Max = math.max(Width - (Width -  32) * Slider.Min / Slider.Max - 32, 1)
		local Position = math.min(math.max(Button:GetHorizontalPosition() + dx, 16), Max + 16)
		
		Button:SetHorizontalPosition(math.floor(Position))
		Slider.Value = (Position - 16) / Max * Slider.Max
		Slider:OnValue(Slider.Value)
		
	end
	
	Button:OnMouseDrag(x, y, dx, dy)
	
end

local function SliderButtonL(Button)
	
	if Button.IsPressed then
		
		local Slider = Button.Parent
		
		if not Slider.Disabled then
			
			local Button = Slider.Layout.Button
			local Width = Slider:GetWidth()
			local Max = math.max(Width - (Width -  32) * Slider.Min / Slider.Max - 32, 1)
			local Position = math.min(math.max(Button:GetHorizontalPosition() - 2, 16), Max + 16)
			
			Button:SetHorizontalPosition(math.floor(Position))
			Slider.Value = (Position - 16) / Max * Slider.Max
			Slider:OnValue(Slider.Value)
			
		end
		
	end
	
end

local function SliderButtonR(Button)
	
	if Button.IsPressed then
		
		local Slider = Button.Parent
		
		if not Slider.Disabled then
			
			local Button = Slider.Layout.Button
			local Width = Slider:GetWidth()
			local Max = math.max(Width - (Width -  32) * Slider.Min / Slider.Max - 32, 1)
			local Position = math.min(math.max(Button:GetHorizontalPosition() + 2, 16), Max + 16)
			
			Button:SetHorizontalPosition(math.floor(Position))
			Slider.Value = (Position - 16) / Max * Slider.Max
			Slider:OnValue(Slider.Value)
			
		end
		
	end
	
end

function Element:Init()
	Element.Base.Init(self)
	
	local Width, Height = self:GetDimensions()
	
	self.Layout.BorderColor = Element.BorderColor
	self.Layout.BackgroundColor = Element.BackgroundColor
	
	self.Layout.Left = gui.create("Button", "", 0, 0, 16, Height, self)
	self.Layout.Left.Layout.Rounded = true
	self.Layout.Left.Layout.ArcRadius = 4
	self.Layout.Left:SetIcon(Element.Left)
	self.Layout.Left.Update = SliderButtonL
	
	self.Layout.Right = gui.create("Button", "", 0, 0, 16, Height, self)
	self.Layout.Right.Layout.Rounded = true
	self.Layout.Right.Layout.ArcRadius = 4
	self.Layout.Right:SetIcon(Element.Right)
	self.Layout.Right.Update = SliderButtonR
	
	self.Layout.Button = gui.create("Button", "", 16, 0, Width - 32, Height, self)
	self.Layout.Button.Layout.Rounded = true
	self.Layout.Button.Layout.ArcRadius = 4
	self.Layout.Button.Layout.Image = nil
	self.Layout.Button.MouseDrag = SliderButtonDrag
	
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
	
	self.Layout.Button:SetHorizontalPosition(16 + Value * (self:GetWidth() - 32 - self.Layout.Button:GetWidth()) / self.Max)
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
	self.Layout.Right:SetPosition(Width -  16, 0)
	self.Layout.Button:SetDimensions(math.floor((Width - 32) * self.Min/self.Max), Height)
	
end

function Element:RenderSkin(dt)
	
	local Width, Height = self:GetDimensions()
	
	love.graphics.setColor(self.Layout.BorderColor)
	gui.graphics.roundedbox("line", 4, 1, 1, Width - 2, Height - 2)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	gui.graphics.roundedbox("fill", 4, 1, 1, Width - 2, Height - 2)
	
end