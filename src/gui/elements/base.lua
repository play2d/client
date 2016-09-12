local gui = ...
local Element = gui.register("Base")

function Element:Create(Text, x, y, Width, Height, Parent)
	self:SetText(Text)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetParent(Parent)
	self:Init()
	
	return self
end

function Element:typeOf(Type)
	if type(Type) == "string" then
		return Type:lower() == "element_"..self.Type:lower()
	end
	return Type == getmetatable(self)
end

function Element:GetSkin()
	if self.Skin then
		if not self.Base then
			return self.Skin[self.Type]
		end
		local Base = self.Base
		local Type = self.Type
		while Base do
			local Skin = self.Skin[Type]
			if Skin then
				return Skin
			end
			Type = Base.Type
			Base = Base.Base
		end
	end
	return {}
end

function Element:OnMousePressed(x, y, Button, IsTouch)
end

function Element:OnMouseReleased(x, y, Button, IsTouch)
end

function Element:OnMouseDrag(x, y, dx, dy)
end

function Element:OnMouseEnter()
end

function Element:OnMouseExit()
end

function Element:OnMouseMoved(x, y, dx, dy)
end

function Element:OnWheelMoved(x, y)
end

function Element:OnKeyPressed(Key, ScanCode, IsRepeat)
end

function Element:OnKeyReleased(Key, ScanCode)
end

function Element:OnTextInput(Text)
end

function Element:ParentMousePressed(x, y, Button, IsTouch)
end

function Element:ParentMouseReleased(x, y, Button, IsTouch)
end

function Element:MousePressed(x, y, Button, IsTouch)
	self:OnMousePressed(x, y, Button, IsTouch)
	
	local Skin = self:GetSkin()
	if Skin.MousePressed then
		Skin.MousePressed(self, x, y, Button, IsTouch)
	end
end

function Element:MouseReleased(x, y, Button, IsTouch)
	self:OnMouseReleased(x, y, Button, IsTouch)
	
	local Skin = self:GetSkin()
	if Skin.MouseReleased then
		Skin.MouseReleased(self, x, y, Button, IsTouch)
	end
end

function Element:MouseDrag(x, y, dx, dy)
	self:OnMouseDrag(x, y, dx, dy)
end

function Element:MouseEnter()
	self:OnMouseEnter()
	
	local Skin = self:GetSkin()
	if Skin.MouseEnter then
		Skin.MouseEnter(self)
	end
end

function Element:MouseExit()
	self:OnMouseExit()
	
	local Skin = self:GetSkin()
	if Skin.MouseExit then
		Skin.MouseExit(self)
	end
end

function Element:MouseMoved(x, y, dx, dy)
	self:OnMouseMoved(x, y, dx, dy)
	
	local Skin = self:GetSkin()
	if Skin.MouseMoved then
		Skin.MouseMoved(self, x, y, dx, dy)
	end
end

function Element:WheelMoved(x, y)
	self:OnWheelMoved(x, y)
	
	local Skin = self:GetSkin()
	if Skin.WheelMoved then
		Skin.WheelMoved(self, x, y)
	end
end

function Element:KeyPressed(Key, ScanCode, IsRepeat)
	self:OnKeyPressed(Key, ScanCode, IsRepeat)
end

function Element:KeyReleased(Key, ScanCode)
	self:OnKeyReleased(Key, ScanCode)
end

function Element:TextInput(Text)
	self:OnTextInput(Text)
end

function Element:LoadSkin(File)
	local Success, Error = pcall(love.filesystem.load, File)
	if Success then
		local Success, Skin = pcall(Error)
		if Success then
			self.Skin = Skin
			return true
		end
		return false, Skin
	end
	return false, Error
end

function Element:SetParent(Parent)
	if self.Parent then
		self.Parent:RemoveChild(self)
	end
	
	if Parent then
		if self.Parent and self.Parent.Skin == self.Skin then
			self.Skin = nil
		end
		Parent:AddChild(self)
	else
		self.Parent = nil
		self.ID = nil
	end
end

function Element:Remove()
	self:SetParent(nil)
end

function Element:SetText(Text)
	if self.Text then
		self.Text:SetText(Text)
	else
		self.Text = gui.CreateText(Text)
	end
	self.Changed = true
	return self
end

function Element:GetText()
	if self.Text then
		return self.Text:Get()
	end
	return ""
end

function Element:SetHorizontalPosition(x)
	self.x = x
end

function Element:SetVerticalPosition(y)
	self.y = y
end

function Element:SetPosition(x, y)
	self:SetHorizontalPosition(x)
	self:SetVerticalPosition(y)
end

function Element:GetHorizontalPosition()
	return math.floor(self.x)
end

function Element:GetVerticalPosition()
	return math.floor(self.y)
end

function Element:GetPosition()
	return self:GetHorizontalPosition(), self:GetVerticalPosition()
end

function Element:GetAbsolutePosition()
	if self.Parent then
		local x1, y1 = self:GetPosition()
		local x2, y2 = self.Parent:GetAbsolutePosition()
		return x1 + x2, y1 + y2
	end
	return self:GetPosition()
end

function Element:AdviseChildDimensions(Child, Width, Height)
end

function Element:SetDimensions(Width, Height)
	if Width ~= self.Width or Height ~= self.Height then
		self.Width = Width
		self.Height = Height
		
		if Width > 0 and Height > 0 then
			local Skin = self:GetSkin()
			if Skin and Skin.SetDimensions then
				Skin.SetDimensions(self, Width, Height)
			end
			
			if self.Canvas or self.SetupCanvas then
				self.Canvas = love.graphics.newCanvas(Width, Height)
				self.Changed = true
			end
			
			if self.Parent then
				self.Parent:AdviseChildDimensions(self, Width, Height)
			end
		else
			self.Canvas = nil
		end
	end
end

function Element:GetWidth()
	return self.Width or 0
end

function Element:GetHeight()
	return self.Height or 0
end

function Element:GetDimensions()
	return self:GetWidth(), self:GetHeight()
end

function Element:UpdateLayout()
	local Skin = self:GetSkin()
	if Skin.UpdateLayout then
		Skin.UpdateLayout(self, x, y)
	end
end

function Element:Update(dt)
	if self.Changed then
		if self.Canvas then
			gui.Current = self
			
			love.graphics.setCanvas(self.Canvas)
			love.graphics.clear(0, 0, 0, 0)
		
			self:UpdateLayout()
			self:RenderSkin()
			
			love.graphics.setCanvas()
		end
		self.Changed = nil
	end
end

function Element:RenderSkin()
	local Skin = self:GetSkin()
	if Skin.Render then
		Skin.Render(self)
	end
end

function Element:Paint(x, y)
	local Skin = self:GetSkin()
	if Skin.Paint then
		Skin.Paint(self, x, y)
	end
end

function Element:Render(x, y)
	
	if self.Canvas then
		
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.Canvas, x, y)
		
	end
	
	self:Paint(x, y)
	
end

function Element:SetHover()
	
	if self.Parent then
		
		local ChildrenRender = {}
		
		for _, Child in pairs(self.Parent.ChildrenRender) do
			
			if Child ~= self then
				
				table.insert(ChildrenRender, Child)
				
			end
			
		end
		
		table.insert(ChildrenRender, self)
		
		self.Parent.ChildrenRender = ChildrenRender
		self.Parent:SetHover()
		
	end
	
end

function Element:MakePopup()
	
	local Skin = self:GetSkin()
	
	if Skin.MakePopup then
		
		Skin.MakePopup(self)
		
	end
	
end

function Element:MakePulldown(TopElement)
	
	local Skin = self:GetSkin()
	
	if Skin.MakePulldown then
		
		Skin.MakePulldown(self, TopElement)
		
	end
	
end

function Element:LocalPointInArea(x, y)
	
	local Width, Height = self:GetDimensions()
	
	return Width and Height and x > 0 and y > 0 and x < Width and y < Height
	
end

function Element:SetLayoutStyle(Style, Value)
	
	self.Layout[Style] = Value
	self.Changed = true
	
end

function Element:GetLayoutStyle(Style)
	
	return self.Layout[Style]
	
end