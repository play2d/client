local TListbox = {}
local TListboxMetatable = {__index = TListbox}
TListbox.Type = "Listbox"
setmetatable(TListbox, gui.TGadgetMetatable)

function gui.CreateListbox(x, y, Width, Height, Parent)
	local Listbox = TListbox.New()
	if Parent:AddGadget(Listbox) then
		Listbox:SetPosition(x, y)
		Listbox:SetSize(Width, Height)
		return Listbox:Init()
	end
end

function TListbox.New()
	return setmetatable({}, TListboxMetatable)
end

function TListbox:OnSelect(Index)
end

function TListbox:Init()
	self.Items = {}
	gui.CreateSlider(gui.SLIDER_VER, self.Size.Width - 12, 1, 12, self.Size.Height - 2, self, 1, 1)
	return self
end

function TListbox:AddGadget(Gadget)
	if Gadget.Type == "Slider" and not self.Slider then
		self.Slider = Gadget
		Gadget.Parent = self
		Gadget.Theme = self.Theme
		Gadget.Hidden = true
		return true
	end
end

function TListbox:SetItem(Index, Item)
	self.Items[Index] = Item

	local Count = 0
	for _, Item in pairs(self.Items) do
		Count = Count + 1
	end
	self.Slider.Values = {}
	self.Slider.Values.Count = self.Size.Height
	self.Slider.Values.Max = Count * (self:GetFont():getHeight() + 5) - self.Size.Height
	self.Slider.Hidden = self.Slider.Values.Max < self.Slider.Values.Count
end

function TListbox:HoverGadget()
	if not self.Hidden then
		local HoverGadget = self.Slider:HoverGadget()
		if HoverGadget then
			return HoverGadget
		end
		if self:MouseHover() then
			return self
		end
	end
end

function TListbox:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:Width(), self:Height()
		local Theme = self:GetTheme()

		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)

		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)

		love.graphics.setColor(unpack(Theme.Text))
		local FontHeight = self:GetFont():getHeight()
		local HeightOffset = -self.Slider.Value
		for Index, Item in pairs(self.Items) do
			if HeightOffset >= -FontHeight then
				if HeightOffset > Height then
					break
				end
				love.graphics.print(Item, x + 2.5, y + HeightOffset + 2.5)
				if self.Selected == Index then
					love.graphics.setColor(unpack(Theme.Selected))
					love.graphics.rectangle("fill", x + 2.5, y + HeightOffset, Width - 5, FontHeight + 5)
					love.graphics.setColor(unpack(Theme.Text))
				elseif self:MouseHoverArea(0, HeightOffset, Width, FontHeight + 2) and self:IsFirst() then
					love.graphics.setColor(unpack(Theme.Hover))
					love.graphics.rectangle("fill", x + 2.5, y + HeightOffset, Width - 5, FontHeight + 5)
					love.graphics.setColor(unpack(Theme.Text))
				end
			end
			HeightOffset = HeightOffset + FontHeight + 5
		end
		self.Slider:Render(dt)
	end
end

function TListbox:MouseClicked(x, y)
	if not self.Disabled and not self.Hidden then
		self.Dropped = mil
		self.Grabbed = {x = x - self:x(), y = y - self:y()}
		self:OnClick(self.Grabbed.x, self.Grabbed.y)
		self:SetHoverAll()

		local Width, Height = self:Width(), self:Height()
		local FontHeight = self:GetFont():getHeight()
		local HeightOffset = -self.Slider.Value
		for Index, Item in pairs(self.Items) do
			if HeightOffset >= -FontHeight then
				if HeightOffset > Height then
					break
				end
				if self:MouseHoverArea(0, HeightOffset, Width, FontHeight + 2) then
					self:OnSelect(Index)
					self.Selected = Index
				end
			end
			HeightOffset = HeightOffset + FontHeight + 5
		end
	end
end
