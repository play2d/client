local gui = ...
local Element = gui.register("CollapsibleNode", "Container")

Element.ChildrenHeight = 0
Element.y = 0
Element.Radius = 4

function Element:Create(Text, Radius, Parent)
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetText(Text)
	self:Init()
	
	return self
end

function Element:Init()
	if self.Parent then
		self.Parent:AdviseChildDimensions(self, self.Parent:GetWidth(), self.Parent:GetNodeHeight())
	end
	self.Base.Init(self)
end

function Element:GetHorizontalPosition()
	return 0
end

function Element:GetWidth()
	return self.Parent:GetWidth()
end

function Element:GetHeight()
	if self.Open then
		return math.max(self.Parent:GetNodeHeight(), self.ChildrenHeight)
	end
	return self.Parent:GetNodeHeight()
end

function Element:AdviseChildDimensions()
	local LastHeight = self.ChildrenHeight
	
	self.ChildrenHeight = 0
	for Index, Child in pairs(self.Children) do
		local y = Child:GetVerticalPosition()
		local Height = Child:GetHeight()
		if y + Height > self.ChildrenHeight then
			self.ChildrenHeight = y + Height
		end
	end
	self.ChildrenHeight = self.ChildrenHeight + 5
	if self.ChildrenHeight ~= LastHeight then
		self.Canvas = love.graphics.newCanvas(self.Width, self:GetHeight())
		self.Changed = true
	end
	self.Parent:AdviseChildDimensions(self, self:GetWidth(), self:GetHeight())
end

function Element:SetIcon(Image)
	self.Image = Image
end

function Element:MousePressed(MouseX, MouseY, Button, IsTouch)
	if not self.Disabled and MouseY < self.Parent:GetNodeHeight() then
		self.Open = not self.Open
		
		local Width, Height = self:GetDimensions()
		self.Canvas = love.graphics.newCanvas(Width, Height)
		self.Parent:AdviseChildDimensions(self, Width, Height)
		self.Changed = true
	end
	self:OnMousePressed(MouseX, MouseY, Button, IsTouch)
end

function Element:RenderChildren(...)
	if self.Open then
		-- Do not call a render process if it's not necessary to
		self.Base.RenderChildren(self, ...)
	end
end

function Element:FindMouseHoverChild(x, y)
	if not self.Hidden then
		local Horizontal, Vertical = self:GetPosition()
		local x, y = x - Horizontal, y - Vertical
		
		if self.Open then
			local Element
			for Index, Child in pairs(self.ChildrenRender) do
				local ChildElement = Child:FindMouseHoverChild(x, y)
				if ChildElement then
					Element = ChildElement
				end
			end
			
			if Element then
				return Element
			elseif self:LocalPointInArea(x, y) then
				return self
			end
		elseif self:LocalPointInArea(x, y) then
			return self
		end
	end
end

function Element:FindTopElement()
	if not self.Hidden then
		if self.Open then
			local Element
			for Index, Child in pairs(self.ChildrenRender) do
				if not Child.Hidden then
					local ChildElement = Child:FindTopElement()
					if ChildElement then
						Element = ChildElement
					end
				end
			end
			
			if Element then
				return Element
			end
		end
		return self
	end
end