local gui = ...
local Element = gui.register("Panel", "Container")

Element.BackgroundColor = {240, 240, 240, 255}
Element.BorderColor = {200, 200, 200, 255}

Element.SplashColor = {255, 255, 255, 255}

Element.LineWidth = 1

function Element:Create(x, y, Width, Height, Parent)
	
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetParent(Parent)
	self:Init()
	
	return self
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	self.Layout.BackgroundColor = Element.BackgroundColor
	self.Layout.BorderColor = Element.BorderColor
	
	self.Layout.SplashColor = Element.SplashColor
	
	self.Layout.LineWidth = Element.LineWidth
	
end

function Element:Paint(x, y)
	
	love.graphics.setLineWidth(self.Layout.LineWidth)
	
	local Width, Height = self:GetDimensions()
	
	if self.Splash then
		
		love.graphics.setColor(self.Layout.SplashColor)
		love.graphics.draw(self.Splash, x, y, 0, Width / self.Splash:getWidth(), Height / self.Splash:getHeight())
		
	else
		
		love.graphics.setColor(self.Layout.BackgroundColor)
		love.graphics.rectangle("fill", x, y, Width, Height)
		
		love.graphics.setColor(self.Layout.BorderColor)
		love.graphics.rectangle("line", x, y, Width, Height)
		
	end
	
end

function Element:SetSplash(Splash)
	
	self.Splash = Splash
	
	return self
	
end

function Element:GetSplash()
	
	return self.Splash
	
end