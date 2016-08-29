local gui = ...
local Element = gui.register("ComboBox", "Element")

Element.HeightOffset = 0

function Element:Create(x, y, Width, Height, Parent)
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
end

function Element:Init()
	self.Selected = 0
	self.Item = {}
	self.Base.Init(self)
end

function Element:SetItem(Index, Text)
	if type(Text) == "string" then
		local Skin = self:GetSkin()
		self.Item[Index] = gui.CreateText(Text, Skin.TextFont, 80, 80, 80, 255)
		
		if Skin.UpdateItems then
			Skin.UpdateItems(self)
		end
	elseif Text == nil then
		self.Item[Index] = nil
		
		local Skin = self:GetSkin()
		if Skin.UpdateItems then
			Skin.UpdateItems(self)
		end
	end
	return self
end

function Element:LoseHover()
	self.Open = nil
	self.Parent:AdviseChildDimensions(self, self.Width, self.Height)
end

function Element:UpdateCanvas()
	if self.Open then
		self.Canvas = love.graphics.newCanvas(self.Width, self.Height + self.HeightOffset)
	else
		self.Canvas = love.graphics.newCanvas(self.Width, self.Height)
	end
	self.Changed = true
end

function Element:GetHeight()
	if self.Open then
		return self.Height + self.HeightOffset
	end
	return self.Height
end

function Element:AddItem(Text)
	return self:SetItem(#self.Item + 1, Text)
end

function Element:Select(Index)
	self.Selected = Index or 0
	self.Changed = true
end

function Element:OnSelect(Item)
end