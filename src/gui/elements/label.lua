local gui = ...
local Element = gui.register("Label", "Element")

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}

function Element:Create(Text, x, y, Width, Height, Parent)
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetText(Text)
	self:Init()
	
	return self
end

function Element:Init()
	Element.Base.Init(self)
	
	self.Layout.TextFont = Element.TextFont
	self.Layout.TextColor = Element.TextColor
	
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
end

function Element:UpdateLayout()
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
end

function Element:RenderSkin(dt)
	self.Text:Draw(0, 0)
end

function Element:SetText(Text)
	self.Base.SetText(self, Text)
	self.Parent:AdviseChildDimensions(self, self:GetWidth(), self:GetHeight())
	return self
end