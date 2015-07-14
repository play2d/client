local TCombobox = {}
local TComboboxMetatable = {__index = TCombobox}
TCombobox.Type = "Combobox"
TCombobox.ItemCount = 0
setmetatable(TCombobox, gui.TGadgetMetatable)

function gui.CreateCombobox(x, y, Width, Height, Parent)
	local Combobox = TCombobox.New()
	if Parent:AddGadget(Combobox) then
		Combobox:SetPosition(x, y)
		Combobox:SetSize(Width, Height)
		return Combobox:Init()
	end
end

function TCombobox.New()
	return setmetatable({}, TComboboxMetatable)
end

function TCombobox:OnSelect(Index)
end

function TCombobox:Init()
	self.Items = {}
	return self
end

function TCombobox:Height()
	if self.Open then
		return self.Size.Height + self.ItemCount * (self:GetFont():getHeight() + 5)
	end
	return self.Size.Height
end

function TCombobox:SetItem(Index, Item)
	if not self.Items[Index] then
		self.ItemCount = self.ItemCount + 1
	end
	self.Items[Index] = Item
end

function TCombobox:RemoveItem(Index)
	if self.Items[Index] then
		self.Items[Index] = nil
		self.ItemCount = self.ItemCount - 1
	end
end

function TCombobox:MouseClicked(mx, my)
	if not self.Disabled and not self.Hidden then
		local x, y = self:x(), self:y()
		self.Dropped = mil
		self.Grabbed = {x = mx - x, y = my - y}
		self:OnClick(self.Grabbed.x, self.Grabbed.y)
		self:SetHoverAll()
		self.Open = not self.Open
		
		if not self.Open then
			local HeightOffset = 0
			local Width, Height = self:Width(), self:Height()
			local FontHeight = self:GetFont():getHeight()
			for Index, Item in pairs(self.Items) do
				if self.Selected ~= Index and self:MouseHoverArea(0, Height + HeightOffset, Width, FontHeight + 4.5) then
					self:OnSelect(Index)
					self.Selected = Index
					self.Text = Item
				end
				HeightOffset = HeightOffset + FontHeight + 5
			end
		end
	end
end

function TCombobox:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:Width(), self.Size.Height
		local Theme = self:GetTheme()
		local Font = self:GetFont()
		
		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)
		
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)
		
		love.graphics.setFont(Font)
		if self.Text then
			love.graphics.setColor(unpack(Theme.Text))
			love.graphics.print(self.Text, x + 2.5, y + (Height - Font:getHeight())/2)
		end
		
		if self.Open then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(Theme.DropImage, x + Width, y + (Height + Theme.DropImage:getHeight())/2, math.pi)
			
			local FontHeight = Font:getHeight()
			local BoxHeight = self.ItemCount * (FontHeight + 5)
			love.graphics.setScissor(x, y + Height, Width, BoxHeight)
			
			love.graphics.setColor(unpack(Theme.Border))
			love.graphics.rectangle("line", x, y + Height, Width, BoxHeight)
			
			love.graphics.setColor(unpack(Theme.Background))
			love.graphics.rectangle("fill", x + 1, y + Height + 1, Width - 2, BoxHeight - 2)
			
			love.graphics.setColor(unpack(Theme.Text))
			local HeightOffset = 0
			for Index, Item in pairs(self.Items) do
				love.graphics.print(Item, x + 2.5, y + Height + HeightOffset + 2.5)
				if self.Selected == Index then
					love.graphics.setColor(unpack(Theme.Selected))
					love.graphics.rectangle("fill", x + 1, y + Height + HeightOffset, Width, FontHeight + 5)
					love.graphics.setColor(unpack(Theme.Text))
				elseif self:MouseHoverArea(0, Height + HeightOffset, Width, FontHeight + 4.5) and self:IsHovered() then
					love.graphics.setColor(unpack(Theme.Hover))
					love.graphics.rectangle("fill", x + 1, y + Height + HeightOffset, Width, FontHeight + 5)
					love.graphics.setColor(unpack(Theme.Text))
				end
				HeightOffset = HeightOffset + FontHeight + 5
			end
		else
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(Theme.DropImage, x + Width - Theme.DropImage:getWidth(), y + (Height - Theme.DropImage:getHeight())/2)
		end
	end
end