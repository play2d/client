local gui = ...
local Element = gui.register("Panel", "Container")

function Element:Create(x, y, Width, Height, Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetParent(Parent)
	self:Init()
	
	return self
end

function Element:Init()
	self.Children = {}
	self.ChildrenRender = {}
	self.Layout = {}
	
	self.Changed = true
end

function Element:Paint(x, y)
	local Width, Height = self:GetDimensions()
	
	if self.Splash then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.Splash, x, y, 0, Width / self.Splash:getWidth(), Height / self.Splash:getHeight())
	else
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("fill", x, y, Width, Height)
	end
end

function Element:SetSplash(Splash)
	self.Splash = Splash
	return self
end