local gui = ...
local Element = gui.register("Container", "Base")

Element.Intersect = true

function Element:Init()
	self.Children = {}
	self.ChildrenRender = {}
	self.Layout = {}
	
	local Skin = self:GetSkin()
	if Skin.Init then
		Skin.Init(self)
	end
	
	local Width, Height = self:GetDimensions()
	if Width and Height and Width > 0 and Height > 0 then
		self.Canvas = love.graphics.newCanvas(Width, Height)
	end
	
	self.Changed = true
end

function Element:MousePressed(x, y, Button, IsTouch)
	for Index, Child in pairs(self.Children) do
		Child:ParentMousePressed(x, y, Button, IsTouch)
	end
	
	self:OnMousePressed(x, y, Button, IsTouch)
	
	local Skin = self:GetSkin()
	if Skin.MousePressed then
		Skin.MousePressed(self, x, y, Button, IsTouch)
	end
end

function Element:MouseReleased(x, y, Button, IsTouch)
	for Index, Child in pairs(self.Children) do
		Child:ParentMouseReleased(x, y, Button, IsTouch)
	end
	
	self:OnMouseReleased(x, y, Button, IsTouch)
	
	local Skin = self:GetSkin()
	if Skin.MouseReleased then
		Skin.MouseReleased(self, x, y, Button, IsTouch)
	end
end

function Element:AddChild(Child)
	table.insert(self.ChildrenRender, Child)
	
	local ID = #self.Children + 1
	Child.Parent = self
	Child.ID = ID
	
	if not Child.Skin then
		Child.Skin = self.Skin
	end
	self.Children[ID] = Child
	
	local Skin = self:GetSkin()
	if Skin.AddChild then
		Skin.AddChild(self, Child)
	end
	
	return ID
end

function Element:RemoveChild(Target)
	for Index, Child in pairs(self.Children) do
		if Child == Target then
			self.Parent.Children[Index] = nil
			break
		end
	end
	
	for Index, Child in pairs(self.ChildrenRender) do
		if Child == Target then
			self.Parent.Children[Index] = nil
			break
		end
	end
	
	table.sort(self.Children, function (A, B) return A.ID < B.ID end)
	for Index, Child in pairs(self.Children) do
		Child.ID = Index
	end
end

function Element:UpdateChildren(dt)
	for _, Child in pairs(self.Children) do
		Child:Update(dt)
		if Child.UpdateChildren then
			Child:UpdateChildren(dt)
		end
	end
end

function Element:RenderChildrenCanvas()
	for _, Child in pairs(self.ChildrenRender) do
		if not Child.Hidden then
			if Child.Changed then
				Child.Changed = nil
				Child:RenderSkin()
			end
			if Child.RenderChildrenCanvas then
				Child:RenderChildrenCanvas()
			end
		end
	end
end

function Element:RenderChildren(x, y)
	local IntersectX, IntersectY, IntersectWidth, IntersectHeight = love.graphics.getScissor()
	for _, Child in pairs(self.ChildrenRender) do
		if not Child.Hidden then
			local Horizontal, Vertical = Child:GetPosition()
			local ChildX, ChildY = Horizontal + x, Vertical + y
			if Child.Intersect then
				local Width, Height = Child:GetDimensions()
				if Width and Height then
					love.graphics.intersectScissor(ChildX, ChildY, Width, Height)
				end
			end

			Child:Render(ChildX, ChildY)
			if Child.RenderChildren then
				Child:RenderChildren(ChildX, ChildY)
			end
			love.graphics.setScissor(IntersectX, IntersectY, IntersectWidth, IntersectHeight)
		end
	end
end

function Element:FindMouseHoverChild(x, y)
	if not self.Hidden then
		local Horizontal, Vertical = self:GetPosition()
		local x, y = x - Horizontal, y - Vertical
		
		local Element
		for Index, Child in pairs(self.ChildrenRender) do
			if not Child.Hidden then
				local ChildElement = Child:FindMouseHoverChild(x, y)
				if ChildElement then
					Element = ChildElement
				end
			end
		end
		
		if Element then
			return Element
		elseif self:LocalPointInArea(x, y) then
			return self
		end
	end
end

function Element:FindTopElement()
	if not self.Hidden then
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
		return self
	end
end