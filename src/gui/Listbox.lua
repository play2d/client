local TListbox = {}
local TListboxMetatable = {__index = TListbox}
TListbox.Type = "Listbox"
TListbox.ItemCount = 0
setmetatable(TListbox, gui.TGadgetMetatable)

function gui.CreateListbox(x, y, Width, Height, Parent)
	local Listbox = TListbox.New()
	if Parent:AddGadget(Listbox) then
		Listbox:SetPosition(x, y)
		Listbox:SetDimensions(Width, Height)
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
	self.Slider = gui.CreateSlider(gui.SLIDER_VER, self.Size.Width - 12, 1, 12, self.Size.Height - 2, self, 1, 1)
	return self
end

function TListbox:AddGadget(Gadget)
	if Gadget.Heading == gui.SLIDER_VER then
		if not self.Slider then
			Gadget.Parent = self
			Gadget.Theme = self.Theme
			Gadget.Hidden = true
			return true
		end
	end
	return self.BaseClass.AddGadget(self, Gadget)
end

function TListbox:SetDimensions(Width, Height)
	self.Size = {Width = Width, Height = Height}
	if self.Slider then
		self.Slider:SetPosition(Width - 12, 1)
		self.Slider:SetDimensions(12, Height - 2)
	end
end

function TListbox:SetItem(Index, Item)
	if not self.Items[Index] then
		self.ItemCount = self.ItemCount + 1
	end
	self.Items[Index] = Item
	
	self.Slider.Values = {}
	self.Slider.Values.Count = self.Size.Height
	self.Slider.Values.Max = self.ItemCount * (self:GetFont():getHeight() + 5)
	self.Slider.Hidden = self.Slider.Values.Max < self.Slider.Values.Count
end

function TListbox:RemoveItem(Index)
	if self.Items[Index] then
		self.Items[Index] = nil
		self.ItemCount = self.ItemCount - 1
	end
end

function TListbox:HoverGadget()
	if not self.Hidden then
		local HoverGadget = self.Slider:HoverGadget()
		if HoverGadget then
			return HoverGadget
		end
		return self.BaseClass.HoverGadget(self)
	end
end

function TListbox:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:GetDimensions()
		local Theme = self:GetTheme()
		local Font = self:GetFont()

		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)

		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)

		love.graphics.setColor(unpack(Theme.Text))
		love.graphics.setFont(Font)
		local FontHeight = Font:getHeight()
		local HeightOffset = -self.Slider.Value * (self.ItemCount * (FontHeight + 5) - Height) / (self.ItemCount * (FontHeight + 5))
		local FirstItem = math.floor((self.Slider.Value / (FontHeight + 5)) * (self.ItemCount * (FontHeight + 5) - Height + FontHeight + 5) / (self.ItemCount * (FontHeight + 5)))
		local LastItem = FirstItem + math.min(self.ItemCount, math.ceil(Height / (FontHeight + 5)))
		for Index = FirstItem, LastItem do
			local Item = self.Items[Index]
			if Item then
				love.graphics.print(Item, x + 2.5, y + (Index - 1) * (FontHeight + 5) + 2.5 + HeightOffset)
				if self.Selected == Index then
					love.graphics.setColor(unpack(Theme.Selected))
					love.graphics.rectangle("fill", x + 2.5, y + (Index - 1) * (FontHeight + 5) + HeightOffset, Width - 5, FontHeight + 5)
					love.graphics.setColor(unpack(Theme.Text))
				elseif self:MouseHoverArea(0, (Index - 1) * (FontHeight + 5) + HeightOffset, Width, FontHeight + 4.5) and self:IsHovered() then
					love.graphics.setColor(unpack(Theme.Hover))
					love.graphics.rectangle("fill", x + 2.5, y + (Index - 1) * (FontHeight + 5) + HeightOffset, Width - 5, FontHeight + 5)
					love.graphics.setColor(unpack(Theme.Text))
				end
			end
		end
		self.Slider:Render(dt)
		self:RenderGadgets(dt)
	end
end

function TListbox:MouseClicked(x, y)
	if not self.Disabled and not self.Hidden then
		self.Dropped = mil
		self.Grabbed = {x = x - self:x(), y = y - self:y()}
		self:OnClick(self.Grabbed.x, self.Grabbed.y)
		self:SetHoverAll()
		if self.Context then
			self.Context.Hidden = true
		end

		local Width, Height = self:GetDimensions()
		local FontHeight = self:GetFont():getHeight()
		local HeightOffset = -self.Slider.Value * (self.ItemCount * (FontHeight + 5) - Height) / (self.ItemCount * (FontHeight + 5))
		local FirstItem = math.floor((self.Slider.Value / (FontHeight + 5)) * (self.ItemCount * (FontHeight + 5) - Height + FontHeight + 5) / (self.ItemCount * (FontHeight + 5)))
		local LastItem = FirstItem + math.min(self.ItemCount, math.ceil(Height / (FontHeight + 5)))
		for Index = FirstItem, LastItem do
			if self.Items[Index] then
				if self:MouseHoverArea(0, (Index - 1) * (FontHeight + 5) + HeightOffset, Width, FontHeight + 4.5) then
					self:OnSelect(Index)
					self.Selected = Index
				end
			end
		end
	end
end
