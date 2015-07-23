local TTabber = {}
local TTabberMetatable = {__index = TTabber}
TTabber.Type = "Tabber"
setmetatable(TTabber, gui.TGadgetMetatable)

function gui.CreateTabber(x, y, Parent)
	local Tabber = TTabber.New()
	if Parent:AddGadget(Tabber) then
		Tabber:SetPosition(x, y)
		return Tabber:Init()
	end
end

function TTabber:OnSelect(Index)
	-- Callback
end

function TTabber.New()
	return setmetatable({}, TTabberMetatable)
end

function TTabber:Init()
	self.Size = {Width = 0, Height = 0}
	self.Items = {}
	return self
end

function TTabber:Height()
	return self:GetFont():getHeight() + 5
end

function TTabber:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Font = self:GetFont()
		local Height = self:Height()
		local Theme = self:GetTheme()
		love.graphics.setFont(Font)

		local Offset = 0
		for Index, Item in pairs(self.Items) do
			local ItemTheme = Item.Theme or Theme
			local Width = Item.Width + 5

			love.graphics.setScissor(x - 1, y - 4, Width + 2, Height + 6)
			if self.Selected == Index then
				love.graphics.setColor(unpack(ItemTheme.Border))
				love.graphics.rectangle("line", x, y - 3, Width, Height + 3)

				love.graphics.setColor(unpack(ItemTheme.HoldTop))
				love.graphics.rectangle("fill", x, y - 3, Width, Height/2 + 1.5)

				love.graphics.setColor(unpack(ItemTheme.HoldBottom))
				love.graphics.rectangle("fill", x, y + Height/2 - 1.5, Width, Height/2 + 1.5)

				love.graphics.setColor(unpack(ItemTheme.Text))
				love.graphics.print(Item.Text, x + 2.5, y + 1)
			elseif self:IsHovered() and self:MouseHoverArea(Offset, 0, Width, Height) then
				love.graphics.setColor(unpack(ItemTheme.Border))
				love.graphics.rectangle("line", x, y, Width, Height)

				love.graphics.setColor(unpack(ItemTheme.HoverTop))
				love.graphics.rectangle("fill", x, y, Width, Height/2)

				love.graphics.setColor(unpack(ItemTheme.HoverBottom))
				love.graphics.rectangle("fill", x, y + Height/2, Width, Height/2)

				love.graphics.setColor(unpack(ItemTheme.Text))
				love.graphics.print(Item.Text, x + 2.5, y + 2.5)
			else
				love.graphics.setColor(unpack(ItemTheme.Border))
				love.graphics.rectangle("line", x, y, Width, Height)

				love.graphics.setColor(unpack(ItemTheme.Top))
				love.graphics.rectangle("fill", x, y, Width, Height/2)

				love.graphics.setColor(unpack(ItemTheme.Bottom))
				love.graphics.rectangle("fill", x, y + Height/2, Width, Height/2)

				love.graphics.setColor(unpack(ItemTheme.Text))
				love.graphics.print(Item.Text, x + 2.5, y + 2.5)
			end
			Offset = Offset + Width + 1
			x = x + Width + 1
		end
		self:RenderGadgets(dt)
	end
end

function TTabber:MouseClicked(x, y)
	if not self.Disabled and not self.Hidden then
		self.Dropped = mil
		self.Grabbed = {x = x - self:x(), y = y - self:y()}
		self:OnClick(self.Grabbed.x, self.Grabbed.y)
		self:SetHoverAll()

		local Font = self:GetFont()
		local Offset, Height = 0, self:Height()
		for Index, Item in pairs(self.Items) do
			local Width = Item.Width + 5
			if self.Selected ~= Index and self:GetHoverAll() == self and self:MouseHoverArea(Offset, 0, Width, Height) then
				self:OnSelect(Index)
				self.Selected = Index
			end
			Offset = Offset + Width + 1
		end
	end
end

function TTabber:SetItem(Index, Text, R, G, B, A, Mult)
	local Font = self:GetFont()
	local Item = {
		Text = Text,
		Width = Font:getWidth(Text)
	}
	if R or G or B or A then
		local R, G, B, A, Mult = R or 255, G or 255, B or 255, A or 255, Mult or 1
		local Theme = self.Theme.Tabber
		Item.Theme = {
			Border = {
				Theme.Border[1] / 255 * R * Mult,
				Theme.Border[2] / 255 * G * Mult,
				Theme.Border[3] / 255 * B * Mult,
				Theme.Border[4] / 255 * A * Mult,
			},
			Top = {
				Theme.Top[1] / 255 * R * Mult,
				Theme.Top[2] / 255 * G * Mult,
				Theme.Top[3] / 255 * B * Mult,
				Theme.Top[4] / 255 * A * Mult,
			},
			Bottom = {
				Theme.Bottom[1] / 255 * R * Mult,
				Theme.Bottom[2] / 255 * G * Mult,
				Theme.Bottom[3] / 255 * B * Mult,
				Theme.Bottom[4] / 255 * A * Mult,
			},
			Text = {
				Theme.Text[1] / 255 * R * Mult,
				Theme.Text[2] / 255 * G * Mult,
				Theme.Text[3] / 255 * B * Mult,
				Theme.Text[4] / 255 * A * Mult,
			},
			HoverTop = {
				Theme.HoverTop[1] / 255 * R * Mult,
				Theme.HoverTop[2] / 255 * G * Mult,
				Theme.HoverTop[3] / 255 * B * Mult,
				Theme.HoverTop[4] / 255 * A * Mult,
			},
			HoverBottom = {
				Theme.HoverBottom[1] / 255 * R * Mult,
				Theme.HoverBottom[2] / 255 * G * Mult,
				Theme.HoverBottom[3] / 255 * B * Mult,
				Theme.HoverBottom[4] / 255 * A * Mult,
			},
			HoverText = {
				Theme.HoverText[1] / 255 * R * Mult,
				Theme.HoverText[2] / 255 * G * Mult,
				Theme.HoverText[3] / 255 * B * Mult,
				Theme.HoverText[4] / 255 * A * Mult,
			},
			HoldTop = {
				Theme.HoldTop[1] / 255 * R * Mult,
				Theme.HoldTop[2] / 255 * G * Mult,
				Theme.HoldTop[3] / 255 * B * Mult,
				Theme.HoldTop[4] / 255 * A * Mult,
			},
			HoldBottom = {
				Theme.HoldBottom[1] / 255 * R * Mult,
				Theme.HoldBottom[2] / 255 * G * Mult,
				Theme.HoldBottom[3] / 255 * B * Mult,
				Theme.HoldBottom[4] / 255 * A * Mult,
			},
			HoldText = {
				Theme.HoldText[1] / 255 * R * Mult,
				Theme.HoldText[2] / 255 * G * Mult,
				Theme.HoldText[3] / 255 * B * Mult,
				Theme.HoldText[4] / 255 * A * Mult,
			},
		}
	end
	self.Items[Index] = Item
	self.Size.Width = 0
	for _, Item in pairs(self.Items) do
		self.Size.Width = self.Size.Width + Item.Width + 6
	end
end

function TTabber:ClearItems()
	if self.Items then
		self.Items = {}
		self.Size.Width = 0
	end
end
