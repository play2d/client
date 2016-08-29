local gui = ...
local Element = gui.register("Desktop", "Container")

function Element:Create()
	self:SetPosition(0, 0)
	self:Init()
	
	return self
end

function Element:Init()
	self.Children = {}
	self.ChildrenRender = {}
end

function Element:GetWidth()
	return love.graphics.getWidth()
end

function Element:GetHeight()
	return love.graphics.getHeight()
end

function Element:FindTopElement()
	local TopElement = self.Base.FindTopElement(self)
	if TopElement == self then
		return nil
	end
	return TopElement
end

function Element:FindMouseHoverChild(x, y)
	local MouseHoverChild = self.Base.FindMouseHoverChild(self, x, y)
	if MouseHoverChild == self then
		return nil
	end
	return MouseHoverChild
end

function Element:Update(dt)
	local LastTopElement = self.TopElement
	local TopElement = self:FindTopElement()
	if TopElement ~= LastTopElement then
		if LastTopElement then
			LastTopElement.IsTop = nil
			LastTopElement:MakePulldown(TopElement)
		end
		
		if TopElement then
			TopElement.IsTop = true
			self.TopElement = TopElement
			self.TopElement:MakePopup()
		end
	end
	self:UpdateChildren(dt)
end

function Element:Render(dt, x, y)
	
	local Width, Height = self:GetDimensions()
	
	self:RenderChildrenCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setScissor(x, y, Width, Height)
	
	if self.Splash then
		love.graphics.draw(self.Splash, x, y, 0, Width / self.Splash:getWidth(), Height / self.Splash:getHeight())
	end
	
	self:RenderChildren(x, y)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setCanvas()
	love.graphics.setScissor()
end

function Element:MousePressed(MouseX, MouseY, Button, IsTouch)
	if self.HoverElement then
		self.HoverElement:SetHover()
		
		local x, y = self.HoverElement:GetAbsolutePosition()
		self.GrabElement = self.HoverElement
		self.GrabElement.IsPressed = true
		self.GrabElement:MousePressed(MouseX - x, MouseY - y, Button, IsTouch)
	end
end

function Element:MouseReleased(x, y, Button, IsTouch)
	if self.GrabElement then
		self.GrabElement.IsPressed = nil
		self.GrabElement.Grab = nil
		self.GrabElement:MouseReleased(x, y, Button, IsTouch)
		self.GrabElement = nil
	end
end

function Element:MouseMoved(x, y, dx, dy)
	local HoverElement = self:FindMouseHoverChild(x, y)
	
	if self.HoverElement and HoverElement ~= self.HoverElement then
		if HoverElement then
			local ElementX, ElementY = HoverElement:GetAbsolutePosition()
			HoverElement.IsHover = {x = x - ElementX, y = y - ElementY}
			HoverElement:MouseEnter()
		end
		self.HoverElement.IsHover = nil
		self.HoverElement:MouseExit()
		self.HoverElement = nil
	end
	
	if HoverElement then
		local ElementX, ElementY = HoverElement:GetAbsolutePosition()
		HoverElement.IsHover = {x = x - ElementX, y = y - ElementY}
		self.HoverElement = HoverElement
		self.HoverElement:MouseMoved(x - ElementX, y - ElementY, dx, dy)
	end
	
	if self.GrabElement then
		local ElementX, ElementY = self.GrabElement:GetAbsolutePosition()
		self.GrabElement:MouseDrag(x - ElementX, y - ElementY, dx, dy)
		self.GrabElement.Grab = {x = x - ElementX, y = y - ElementY}
	end
end

function Element:WheelMoved(x, y)
	if self.HoverElement then
		self.HoverElement:WheelMoved(x, y)
	end
end

function Element:KeyPressed(Key, ScanCode, IsRepeat)
	if self.TopElement then
		self.TopElement:KeyPressed(Key, ScanCode, IsRepeat)
	end
end

function Element:TextInput(Key)
	if self.TopElement then
		self.TopElement:TextInput(Key)
	end
end

function Element:SetSplash(Splash)
	self.Splash = Splash
	return self
end