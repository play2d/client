local TCombofield = {}
local TCombofieldMetatable = {__index = TCombofield}
TCombofield.Type = "Combofield"
TCombofield.Text = ""
TCombofield.HintText = ""
TCombofield.TextOffset = -2.5
TCombofield.Start = 0
TCombofield.Length = 0
TCombofield.ItemCount = 0
TCombofield.Writeable = true
setmetatable(TCombofield, gui.TGadgetMetatable)

function gui.CreateCombofield(x, y, Width, Height, Parent)
	local Combofield = TCombofield.New()
	if Parent:AddGadget(Combofield) then
		Combofield:SetPosition(x, y)
		Combofield:SetDimensions(Width, Height)
		return Combofield:Init()
	end
end

function TCombofield.New()
	return setmetatable({}, TCombofieldMetatable)
end

function TCombofield:OnSelect(Index)
end

function TCombofield:SetText(Text)
	self.Text = Text
	self.Start = #Text
	self.Length = 0
end

function TCombofield:Init()
	self.Items = {}
	self.HintText = Text
	self.Timer = love.timer.getTime()
	return self
end

function TCombofield:Write(Text)
	if not self.Hidden and not self.Disabled then
		local Length = #Text
		if self.Length == 0 then
			if self.Start == #self.Text then
				self.Text = self.Text .. Text
			elseif self.Start < #self.Text then
				self.Text = self.Text:sub(1, self.Start) .. Text .. self.Text:sub(self.Start + 1)
			end
			self.Start = self.Start + Length
		elseif self.Length > 0 then
			self.Text = self.Text:sub(1, self.Start) .. Text .. self.Text:sub(self.Start + self.Length + 1)
			self.Start = self.Start + Length
			self.Length = 0
		elseif self.Length < 0 then
			self.Text = self.Text:sub(1, self.Start + self.Length) .. Text .. self.Text:sub(self.Start + 1)
			self.Start = self.Start + self.Length + Length
			self.Length = 0
		end

		if self.Password then
			Text = string.rep("*", Length)
		end
		local Font = self:GetFont()
		local Width = Font:getWidth(Text)
		if Font:getWidth(self.Text) + Width > self.TextOffset + self:GetWidth() then
			self.TextOffset = self.TextOffset + Width
		end
	end
end

function TCombofield:keypressed(key)
	if self.Hidden or self.Disabled then
		return nil
	end

	local Text = self.Text
	local Length = #self.Text
	if self.Password then
		Text = string.rep("*", Length)
	end
	local Font = self:GetFont()
	if key == "backspace" then
		if self.Length == 0 then
			local Width = Font:getWidth(Text:sub(self.Start, self.Start))
			if Font:getWidth(Text) - Width > self:GetWidth() then
				self.TextOffset = math.max(self.TextOffset - Width, 0)
			else
				self.TextOffset = 0
			end
			self.Text = self.Text:sub(1, self.Start - 1) .. self.Text:sub(self.Start + 1)
			self.Start = self.Start - 1
		elseif self.Length > 0 then
			self.Text = self.Text:sub(1, self.Start) .. self.Text:sub(self.Start + self.Length + 1)
			self.Start = self.Start
			self.Length = 0
		else
			self.Text = self.Text:sub(1, self.Start + self.Length) .. self.Text:sub(self.Start + 1)
			self.Start = self.Start + self.Length
			self.Length = 0
		end
	elseif key == "delete" then
		if self.Length == 0 then
			self.Text = self.Text:sub(1, self.Start) .. self.Text:sub(self.Start + 1)
		elseif self.Length > 0 then
			self.Text = self.Text:sub(1, self.Start) .. self.Text:sub(self.Start + self.Length + 1)
			self.Start = self.Start
			self.Length = 0
		else
			self.Text = self.Text:sub(1, self.Start + self.Length) .. self.Text:sub(self.Start + 1)
			self.Start = self.Start + self.Length
			self.Length = 0
		end
	elseif key == "left" then
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
				self.Length = math.max(self.Length - 1, -self.Start)
				if self.Length < 0 then
					local Width = Font:getWidth(Text:sub(1, self.Start + self.Length))
					if Width < self.TextOffset then
						self.TextOffset = Width
					end
				elseif self.Length > 0 then
					local Width = Font:getWidth(Text:sub(1, self.Start))
					if Width < self.TextOffset then
						self.TextOffset = Width
					end
				end
		else
			if self.Length == 0 then
				self.Start = math.max(self.Start - 1, 0)
				self.Length = 0
				local Width = Font:getWidth(Text:sub(1, self.Start))
				if Width < self.TextOffset then
					self.TextOffset = Width
				end
			elseif self.Length > 0 then
				self.Length = 0
				local Width = Font:getWidth(Text:sub(1, self.Start))
				if Width < self.TextOffset then
					self.TextOffset = Width
				end
			else
				self.Start = math.max(self.Start + self.Length, 0)
				self.Length = 0
				local Width = Font:getWidth(Text:sub(1, self.Start))
				if Width < self.TextOffset then
					self.TextOffset = Width
				end
			end
		end
	elseif key == "right" then
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
			self.Length = math.min(self.Length + 1, Length - self.Start)
			if self.Length > 0 then
				local Width = Font:getWidth(Text:sub(1, self.Start + self.Length))
				if Width > self.TextOffset + self:GetWidth() then
					self.TextOffset = Width - self:GetWidth()
				end
			elseif self.Length < 0 then
				local Width = Font:getWidth(Text:sub(1, self.Start + self.Length))
				if Width > self.TextOffset + self:GetWidth() then
					self.TextOffset = Width - self:GetWidth()
				end
			end
		else
			if self.Length == 0 then
				self.Start = math.min(self.Start + self.Length + 1, Length)
				self.Length = 0

				local Width = Font:getWidth(Text:sub(1, self.Start))
				if Width > self.TextOffset + self:GetWidth() then
					self.TextOffset = Width - self:GetWidth()
				end
			elseif self.Length > 0 then
				self.Start = math.min(self.Start + self.Length, Length)
				self.Length = 0
				local Width = Font:getWidth(Text:sub(1, self.Start))
				if Width > self.TextOffset + self:GetWidth() then
					self.TextOffset = Width - self:GetWidth()
				end
			else
				self.Length = 0
				local Width = Font:getWidth(Text:sub(1, self.Start))
				if Width > self.TextOffset + self:GetWidth() then
					self.TextOffset = Width - self:GetWidth()
				end
			end
		end
	end
end

function TCombofield:GetCursor()
	if self.Cursor then
		return self.Cursor
	end
	local MouseX, MouseY = love.mouse.getPosition()
	local Theme = self:GetTheme()
	if MouseX - self:x() >= self:GetWidth() - Theme.DropImage:getWidth() or MouseY - self:y() > self.Size.Height then
		return Theme.HandCursor
	end
	return self.BaseClass.GetCursor(self)
end

function TCombofield:MouseClicked(mx, my)
	if self.BaseClass.MouseClicked(self, mx, my) then
		local Theme = self:GetTheme()
		if self.Grabbed.x >= self:GetWidth() - Theme.DropImage:getWidth() or self.Grabbed.y > self.Size.Height then
			self.Open = not self.Open
			if not self.Open then
				local HeightOffset = 0
				local Width, Height = self:GetDimensions()
				local FontHeight = self:GetFont():getHeight()
				for Index, Item in pairs(self.Items) do
					if self.Selected ~= Index and self:MouseHoverArea(0, Height + HeightOffset, Width, FontHeight + 4.5) then
						self:OnSelect(Index)
						self.Selected = Index
						self:SetText(Item)
					end
					HeightOffset = HeightOffset + FontHeight + 5
				end
			end
		else
			local Text = self.Text
			local Length = #self.Text
			if self.Password then
				Text = string.rep("*", Length)
			end
			local SelectPosition = self.Grabbed.x + self.TextOffset
			local TextWidth = 0
			local Font = self:GetFont()
			for i = 1, #self.Text do
				local Width = Font:getWidth(Text:sub(i, i))
				if SelectPosition > TextWidth and SelectPosition <= TextWidth + Width then
					self.Start = i
					self.Length = 0
					TextWidth = TextWidth + Width
					break
				end
				TextWidth = TextWidth + Width
			end
			if SelectPosition > TextWidth then
				self.Start = #self.Text
				self.Length = 0
			elseif SelectPosition <= 0 then
				self.Start = 0
				self.Length = 0
			end
		end
		return true
	end
end

function TCombofield:MouseDropped(x, y)
	if not self.Hidden then
		if self.Grabbed then
			self.Dropped = {x = x - self:x(), y = y - self:y()}
			self:OnDrop(self.Dropped.x, self.Dropped.y)

			if self.Grabbed.y <= self.Size.Height then
				local Text = self.Text
				local Length = #self.Text
				if self.Password then
					Text = string.rep("*", Length)
				end
				local SelectPosition = self.Dropped.x + self.TextOffset
				local TextWidth = 0
				local Font = self:GetFont()
				for i = 1, #self.Text do
					local Width = Font:getWidth(Text:sub(i, i))
					if SelectPosition > TextWidth and SelectPosition <= TextWidth + Width then
						self.Length = i - self.Start
						TextWidth = TextWidth + Width
						break
					end
					TextWidth = TextWidth + Width
				end
				if SelectPosition > TextWidth then
					self.Length = #self.Text - self.Start
				elseif SelectPosition <= 0 then
					self.Length = -self.Start
				end
			end
			self.Grabbed = nil
		end
	end
end

function TCombofield:MouseMove(x, y, dx, dy)
	if not self.Hidden then
		if self.Grabbed then
			local Text = self.Text
			local Length = #self.Text
			if self.Password then
				Text = string.rep("*", Length)
			end
			local SelectPosition = x - self:x() + self.TextOffset
			local TextWidth = 0
			local Font = self:GetFont()
			for i = 1, #self.Text do
				local Width = Font:getWidth(Text:sub(i, i))
				if SelectPosition > TextWidth and SelectPosition <= TextWidth + Width then
					self.Length = i - self.Start
					TextWidth = TextWidth + Width
					break
				end
				TextWidth = TextWidth + Width
			end
			if SelectPosition > TextWidth then
				self.Length = #self.Text - self.Start
			elseif SelectPosition <= 0 then
				self.Length = -self.Start
			end
		end
	end
end

function TCombofield:Copy()
	if not self.Hidden then
		if not self.Password then
			if self.Length > 0 then
				return self.Text:sub(self.Start + 1, self.Start + self.Length)
			elseif self.Length < 0 then
				return self.Text:sub(self.Start + self.Length + 1, self.Start)
			end
		end
	end
end

function TCombofield:GetHeight()
	if self.Open then
		return self.Size.Height + self.ItemCount * (self:GetFont():getHeight() + 5)
	end
	return self.Size.Height
end

function TCombofield:SetItem(Index, Item)
	if not self.Items[Index] then
		self.ItemCount = self.ItemCount + 1
	end
	self.Items[Index] = Item
end

function TCombofield:RemoveItem(Index)
	if self.Items[Index] then
		self.Items[Index] = nil
		self.ItemCount = self.ItemCount - 1
	end
end

function TCombofield:Update(dt)
	if not self.Hidden and not self.Disabled then
		if self.Grabbed then
			local x = love.mouse.getX() - self:x()
			local Width = self:GetWidth()
			if x < -2.5 then
				self.TextOffset = math.max(self.TextOffset + x * dt / 170, -2.5)
			elseif x > Width + 2.5 then
				local Text = self.Text
				local Length = #self.Text
				if self.Password then
					Text = string.rep("*", Length)
				end
				local Font = self:GetFont()
				local TextWidth = Font:getWidth(Text)
				if TextWidth > Width then
					x = x - Width
					self.TextOffset = math.min(self.TextOffset + x * dt / 170, Font:getWidth(Text) - Width + 2.5)
				end
			end
		end
		self:UpdateGadgets(dt)
	end
end

function TCombofield:Render(dt)
	if not self.Hidden then
		local x, y = self:GetPosition()
		local Width, Height = self:GetWidth(), self.Size.Height
		local Theme = self:GetTheme()
		local Font = self:GetFont()
		
		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)
		
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)
		
		if self.Text then
			local TextY = (Height - Font:getHeight())/2
			local Text = self.Text
			local Length = #self.Text
			if self.Password then
				Text = string.rep("*", Length)
			end
			love.graphics.setScissor(x, y, Width, Height)
			love.graphics.setFont(Font)
			if #self.Text > 0 then
				love.graphics.setColor(unpack(Theme.Text))
				love.graphics.print(Text, x - self.TextOffset, y + TextY)
			else
				love.graphics.setColor(unpack(Theme.HintText))
				love.graphics.print(self.HintText, x, y + TextY)
			end

			if not self.Disabled and self:IsFirst() then
				if love.timer.getTime() - self.Timer > 0.5 then
					self.Tick = not self.Tick
					self.Timer = love.timer.getTime()
				end
			elseif self.Tick then
				self.Tick = nil
			end

			if self.Length == 0 then
				if self.Tick then
					love.graphics.print("|", x + Font:getWidth(Text:sub(1, self.Start)) - self.TextOffset - 2, y + TextY)
				end
			else
				love.graphics.setColor(unpack(Theme.SelectedText))
				if self.Length > 0 then
					love.graphics.rectangle("fill", x + Font:getWidth(Text:sub(1, self.Start)) - self.TextOffset, y + TextY, Font:getWidth(Text:sub(self.Start + 1, self.Start + self.Length)), Font:getHeight())
				else
					love.graphics.rectangle("fill", x + Font:getWidth(Text:sub(1, self.Start + self.Length)) - self.TextOffset, y + TextY, Font:getWidth(Text:sub(self.Start + self.Length + 1, self.Start)), Font:getHeight())
				end
			end
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
		self:RenderGadgets(dt)
	end
end