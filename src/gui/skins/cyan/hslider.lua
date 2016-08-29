local Path, gui = ...
local Slider = {}

Slider.Left = love.graphics.newImage(Path.."/Left-14.png")
Slider.Right = love.graphics.newImage(Path.."/Right-14.png")

Slider.BorderColor = {80, 80, 80, 255}
Slider.BackgroundColor = {200, 200, 200, 255}

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

function Slider:Init()
	local Width, Height = self:GetDimensions()
	
	self.Layout.BorderColor = Slider.BorderColor
	self.Layout.BackgroundColor = Slider.BackgroundColor
	
	self.Layout.Left = gui.create("Button", "", 0, 0, 16, Height, self)
	self.Layout.Left.Layout.Rounded = true
	self.Layout.Left.Layout.ArcRadius = 4
	self.Layout.Left:SetIcon(Slider.Left)
	self.Layout.Left.Update = SliderButtonL
	
	self.Layout.Right = gui.create("Button", "", 0, 0, 16, Height, self)
	self.Layout.Right.Layout.Rounded = true
	self.Layout.Right.Layout.ArcRadius = 4
	self.Layout.Right:SetIcon(Slider.Right)
	self.Layout.Right.Update = SliderButtonR
	
	self.Layout.Button = gui.create("Button", "", 16, 0, Width - 32, Height, self)
	self.Layout.Button.Layout.Rounded = true
	self.Layout.Button.Layout.ArcRadius = 4
	self.Layout.Button.Layout.Image = nil
	self.Layout.Button.MouseDrag = SliderButtonDrag
end

function Slider:UpdateValue(Value)
	self.Layout.Button:SetHorizontalPosition(16 + Value * (self:GetWidth() - 32 - self.Layout.Button:GetWidth()) / self.Max)
end

function Slider:UpdateLayout()
	local Width, Height = self:GetDimensions()
	
	self.Layout.Left:SetDimensions(16, Height)
	self.Layout.Right:SetDimensions(16, Height)
	self.Layout.Right:SetPosition(Width -  16, 0)
	self.Layout.Button:SetDimensions(math.floor((Width - 32) * self.Min/self.Max), Height)
end

function Slider:Render(dt)
	local Width, Height = self:GetDimensions()
	
	love.graphics.setColor(self.Layout.BorderColor)
	gui.graphics.roundedbox("line", 4, 1, 1, Width - 2, Height - 2)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	gui.graphics.roundedbox("fill", 4, 1, 1, Width - 2, Height - 2)
end

return Slider