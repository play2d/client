local gui = ...
local Element = gui.register("Tabber", "Container")

-- NOTE THAT MOST OF THE IMPORTANT CODE OF THIS ELEMENT IS STORED ON THE SKIN SCRIPT
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
		self.Item[Index] = gui.CreateText(Text, self.Layout.TextFont, 80, 80, 80, 255)
		self:UpdateItems()
	elseif Text == nil then
		self.Item[Index] = nil
		self:UpdateItems()
	end
	return self
end

function Element:UpdateItems()
	table.sort(self.Item)
	local Skin = self:GetSkin()
	if Skin.UpdateItems then
		Skin.UpdateItems(self)
	end
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