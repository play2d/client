local TListview = {}
local TListviewMetatable = {__index = TListview}
TListview.Type = "Listview"
TListview.ItemCount = 0
setmetatable(TListview, gui.TGadgetMetatable)

function gui.CreateListview(x, y, Height, Parent)
	local Listview = TListview.New()
	if Parent:AddGadget(Listview) then
		Listview:SetPosition(x, y)
		Listview:SetSize(0, Height)
		return Listview:Init()
	end
end

function TListview.New()
	return setmetatable({}, TListviewMetatable)
end

function TListview:OnSelect(Index)
end

function TListview:Init()
	self.Items = {}
	self.Column = {}
	gui.CreateSlider(gui.SLIDER_VER, self.Size.Width - 12, 1, 12, self.Size.Height - 2, self, 1, 1)
	return self
end

function TListview:AddGadget(Gadget)
	if Gadget.Type == "Slider" and not self.Slider then
		self.Slider = Gadget
		Gadget.Parent = self
		Gadget.Theme = self.Theme
		Gadget.Hidden = true
		return true
	end
end

function TListview:SetItem(Index, ...)
	if not self.Items[Index] then
		self.ItemCount = self.ItemCount + 1
	end
	self.Items[Index] = {...}
	
	self.Slider.Values = {}
	self.Slider.Values.Count = self.Size.Height
	self.Slider.Values.Max = self.ItemCount * (self:GetFont():getHeight() + 5)
	self.Slider.Hidden = self.Slider.Values.Max < self.Slider.Values.Count
end

function TListview:AddColumn(Text, Width)
	self:SetColumn(#self.Column + 1, Text, Width)
end

function TListview:SetColumn(Index, Text, Width)
	local Font = self:GetFont()
	if not Width then
		Width = Font:getWidth(Text) + 5
	end
	if self.Column[Index] then
		self.Size.Width = self.Size.Width - self.Column[Index].Width
	end
	self.Size.Width = self.Size.Width + Width
	self.Column[Index] = {Text = Text, Width = Width}
	self.Slider.Offset.x = self.Size.Width - 12
end

function TListview:RemoveColumn(Index)
	if self.Column[Index] then
		local Font = self:GetFont()
		self.Size.Width = self.Size.Width - self.Column[Index].Width
		self.Column[Index] = nil
	end
end

function TListview:RemoveItem(Index)
	if self.Items[Index] then
		self.Items[Index] = nil
		self.ItemCount = self.ItemCount - 1
	end
end

function TListview:HoverGadget()
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

function TListview:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Height = self:Height()
		local Theme = self:GetTheme()
		local Font = self:GetFont()
		
		love.graphics.setFont(Font)
		
		local FontHeight = Font:getHeight()
		for ColumnID, Column in pairs(self.Column) do
			local Width = Column.Width
			local HeightOffset = -self.Slider.Value * (self.ItemCount * (FontHeight + 5) - Height) / (self.ItemCount * (FontHeight + 5))
			love.graphics.setScissor(x, y, Width, Height)
			love.graphics.setColor(unpack(Theme.Border))
			love.graphics.rectangle("line", x, y, Width, Height)
			
			love.graphics.setColor(unpack(Theme.Background))
			love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)
			
			love.graphics.setColor(unpack(Theme.Text))
			for Index, Item in pairs(self.Items) do
				if HeightOffset >= -FontHeight then
					if HeightOffset > Height then
						break
					end
					love.graphics.print(Item[ColumnID], x + 2.5, y + HeightOffset + 2.5)
					if self.Selected == Index then
						love.graphics.setColor(unpack(Theme.Selected))
						love.graphics.rectangle("fill", x + 2.5, y + HeightOffset, Width, FontHeight + 5)
						love.graphics.setColor(unpack(Theme.Text))
					elseif self:MouseHoverArea(0, HeightOffset, self.Size.Width, FontHeight + 2) and self:IsHovered() then
						love.graphics.setColor(unpack(Theme.Hover))
						love.graphics.rectangle("fill", x + 2.5, y + HeightOffset, Width, FontHeight + 5)
						love.graphics.setColor(unpack(Theme.Text))
					end
				end
				HeightOffset = HeightOffset + FontHeight + 5
			end
			x = x + Width - 1
		end
		self.Slider:Render(dt)
	end
end

function TListview:MouseClicked(x, y)
	if not self.Disabled and not self.Hidden then
		self.Dropped = mil
		self.Grabbed = {x = x - self:x(), y = y - self:y()}
		self:OnClick(self.Grabbed.x, self.Grabbed.y)
		self:SetHoverAll()

		local Width, Height = self:Width(), self:Height()
		local FontHeight = self:GetFont():getHeight()
		local HeightOffset = -self.Slider.Value * (self.ItemCount * (FontHeight + 5) - Height) / (self.ItemCount * (FontHeight + 5))
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
