local gui = ...
local Element = gui.register("TextField", "Element")

Element.Selected = 1
Element.SelectedLength = 0

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}
Element.HintColor = {140, 140, 140, 255}
Element.BackgroundColor = {255, 255, 255, 255}
Element.BorderColor = {80, 80, 80, 255}

Element.LineWidth = 1

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:Init()
	
	return self
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	self.Layout.TextFont = Element.TextFont
	self.Layout.TextColor = Element.TextColor
	self.Layout.HintColor = Element.HintColor
	self.Layout.BackgroundColor = Element.BackgroundColor
	self.Layout.BorderColor = Element.BorderColor
	
	self.Text = gui.CreateText()
	self.HintText = gui.CreateText()
	
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.HintText:SetFont(self.Layout.TextFont)
	self.HintText:SetColor(unpack(self.Layout.HintColor))
	
	self.Layout.LineWidth = Element.LineWidth
	
	self.Layout.Offset = 0
	
end

function Element:Filter(Text, Position, Length)
	
	return true
	
end

function Element:CanDelete(Position, Length)
	
	return true
	
end

function Element:TextInput(Text)
	
	if not self.Disabled then
		
		self:Write( Text:gsub("\n", "") )
		
	end
	
	Element.Base.TextInput(self, Text)
	
end

function Element:SetPassword(Password)
	
	self.Text:SetPassword(Password)
	
	return self
	
end

function Element:KeyPressed(Key, ScanCode, IsRepeat)
	
	Element.Base.KeyPressed(self, Key, ScanCode, IsRepeat)
	
	if not self.Disabled then
		
		if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
			
			if Key == "v" then
				
				self:TextInput(love.system.getClipboardText())
				
			elseif Key == "c" then
				
				if not self.Text.Password then
					
					love.system.setClipboardText(self:GetSelectedText())
					
				end
				
			end
			
		elseif Key == "backspace" then
			
			if self.SelectedLength == 0 then
				
				local Min = self.Selected - 1
				local Max = self.Selected
				
				if self:CanDelete(Min, Max - Min) then
					
					self.Text:SetText(self.Text.Text:utf8sub(1, self.Selected - 2) .. self.Text.Text:utf8sub(self.Selected))
					self.Selected = math.max(self.Selected - 1, 1)
					
				end
				
			else
				
				local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
				local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
				
				if self:CanDelete(Min, Max - Min) then
					
					self.Text:SetText(self.Text.Text:utf8sub(1, Min - 1) .. self.Text.Text:utf8sub(Max))
					
					self.Selected = math.max(Min, 1)
					self.SelectedLength = 0
					
				end
				
			end
			
			self:UpdateText()
			
		elseif Key == "delete" then
			
			if self.SelectedLength == 0 then
				
				local Min = self.Selected
				local Max = self.Selected + 1
				
				if self:CanDelete(Min, Max - Min) then
					
					self.Text:SetText(self.Text.Text:utf8sub(1, self.Selected - 1) .. self.Text.Text:utf8sub(self.Selected + 1))
					
				end
				
			else
				
				local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
				local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
				
				if self:CanDelete(Min, Max - Min) then
					
					self.Text:SetText(self.Text.Text:utf8sub(1, Min - 1) .. self.Text.Text:utf8sub(Max))
					
					self.Selected = math.max(Min, 1)
					self.SelectedLength = 0
					
				end
				
			end
			
			self:UpdateText()
			
		elseif Key == "left" then
			
			if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
				
				self.SelectedLength = self.SelectedLength - 1
				
				if self.SelectedLength <= 0 then
					
					if self.Selected + self.SelectedLength < 1 then
						
						self.SelectedLength = 1 - self.Selected
						
					end
					
				end
				
			else
				
				local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
				
				if self.SelectedLength ~= 0 then
					
					if Min > 0 then
						
						self.Selected = Min
						
					end
					
					self.SelectedLength = 0
					
				else
					
					self.Selected = math.max(Min - 1, 1)
					
				end
				
			end
			
			self:UpdateText()
			
		elseif Key == "right" then
			
			if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
				
				self.SelectedLength = self.SelectedLength + 1
				
				if self.SelectedLength >= 0 then
					
					if self.Selected + self.SelectedLength > self.Text.Text:utf8len() + 1 then
						
						self.SelectedLength = self.Text.Text:utf8len() + 1 - self.Selected
						
					end
					
				end
				
			else
				
				local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
				
				if self.SelectedLength ~= 0 then
					
					if Max > 0 then
						
						self.Selected = Max
						
					end
					
					self.SelectedLength = 0
					
				else
					
					self.Selected = math.min(Max + 1, self.Text.Text:utf8len() + 1)
					
				end
				
			end
			
			self:UpdateText()
			
		end
		
		return true
		
	end
	
end

function Element:Write(Text)
	
	local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
	local Max = math.max(self.Selected, self.Selected + self.SelectedLength)

	if (Max - Min == 0 or self:CanDelete(Min, Max - Min, LinePosition)) and self:Filter(Text, Min, Max - Min) then
		
		self.Text:SetText(self.Text.Text:utf8sub(1, Min - 1) .. Text .. self.Text.Text:utf8sub(Max))
		
		self.Selected = math.max(Min + Text:utf8len(), 1)
		self.SelectedLength = 0
		self:UpdateText()
		
	end
	
end

function Element:SetText(Text)
	
	Element.Base.SetText(self, Text)
	self:UpdateText()
	
end

function Element:UpdateText()
	
	local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
	local Offset = -self.Layout.Offset
	
	for i = 1, Min - 1 do
		
		local Format = self.Text.Format[i] or self.Text
		local Char = self.Text.Text:utf8sub(i, i)
		
		local Font = Format.Font or self.Text.Font
		local CharWidth = Font:getWidth(Char)
		
		Offset = Offset + CharWidth
		
	end
	
	local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
	local Offset2 = Offset
	
	for i = Min - 1, Max - 1 do
		
		if i > 0 then
			
			local Format = self.Text.Format[i] or self.Text
			local Char = self.Text.Text:utf8sub(i, i)
			
			local Font = Format.Font or self.Text.Font
			local CharWidth = Font:getWidth(Char)
			
			Offset2 = Offset2 + CharWidth
			
		end
		
	end
	
	local Horizontal = self:GetHorizontalPosition()
	local Width = self:GetWidth()

	if Offset > Width - 10 then
		
		self.Layout.Offset = self.Layout.Offset + Offset - Width + 10
		
	elseif Offset2 > Width then
		
		self.Layout.Offset = self.Layout.Offset + Offset2 - Width
		
	elseif Offset < 0 then
		
		self.Layout.Offset = self.Layout.Offset + Offset
		
	end
	
	self.Changed = true
	
end

function Element:GetMousePosition(x, y)
	
	return self.Text:GetPosition(x + self.Layout.Offset, y)
	
end

function Element:MousePressed(x, y, Button, IsTouch, ...)
	
	if Button == 1 and not self.Disabled then
		
		if Button == 1 then
			
			self.Selected = self:GetMousePosition(x, y)
			self.SelectedLength = 0
			self.Changed = true
			
		end
		
	end
	
	Element.Base.MousePressed(self, x, y, Button, IsTouch, ...)
	
end

function Element:MouseDrag(x, y, dx, dy)
	
	if not self.Disabled then
		
		self.SelectedLength = self:GetMousePosition(x, y) - self.Selected
		self.Changed = true
		
	end
	
	Element.Base.MouseDrag(self, x, y, dx, dy)
	
end

function Element:MakePopup()
	
	Element.Base.MakePopup(self)
	
	if gui.Mobile then
		
		love.keyboard.setTextInput(true)
		
	end
	
end

function Element:MakePulldown()
	
	Element.Base.MakePulldown(self)
	
	self.Changed = true
	
	if gui.Mobile then
		
		love.keyboard.setTextInput(false)
		
	end
end

function Element:SetHintText(Text)
	
	self.HintText:SetText(Text)
	self.Changed = true
	
	return self
	
end

function Element:Select(Start, Length)
	
	self.Selected = Start
	self.SelectedLength = Length or 0
	self.Changed = true
	
end

function Element:GetSelection()
	
	return math.min(self.Selected, self.Selected + self.SelectedLength), math.max(self.Selected, self.Selected + self.SelectedLength) - 1
	
end

function Element:GetSelectedText()
	
	return self.Text.Text:utf8sub(self:GetSelection())
	
end

function Element:MoveLeft(Offset)
	
	self.Layout.Offset = math.max(self.Layout.Offset - Offset, 1)
	self.Changed = true
	
end

function Element:MoveRight(Offset)
	
	self.Layout.Offset = math.max(math.min(self.Layout.Offset + Offset, self.Text:getWidth() - self:GetWidth()), 0)
	self.Changed = true
	
end

function Element:Update()
	
	if self.Grab then
		
		if self.Grab.x < 5 then
			
			self:MoveLeft((5 - self.Grab.x)/5)
			self:MouseDrag(self.Grab.x, self.Grab.y, 0, 0)
			
		elseif self.Grab.x > self:GetWidth() then
			
			self:MoveRight((self.Grab.x - self:GetWidth())/5)
			self:MouseDrag(self.Grab.x, self.Grab.y, 0, 0)
			
		end
		
	end
	
	Element.Base.Update(self)
	
end

function Element:UpdateLayout()
	
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
	
	self.HintText:SetFont(self.Layout.TextFont)
	self.HintText:SetColor(unpack(self.Layout.HintColor))
	
end

function Element:RenderSkin()
	
	love.graphics.setLineWidth(self.Layout.LineWidth)
	
	local Width, Height = self:GetDimensions()
	
	love.graphics.setColor(unpack(self.Layout.BorderColor))
	love.graphics.rectangle("line", 1, 1, Width - 2, Height - 2)
	
	love.graphics.setColor(unpack(self.Layout.BackgroundColor))
	love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2)
	
	if self.Text.Text:utf8len() > 0 or self.IsTop then
		
		self.Text:Draw(5 - self.Layout.Offset, (self:GetHeight() - self.Text:getHeight())/2)
		
		if self.SelectedLength ~= 0 then
			
			local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
			local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
			local Offset = -self.Layout.Offset + 5
			
			if self.Text.Password then
				
				for i = 1, Min - 1 do
					
					local Format = self.Text.Format[i] or self.Text
					local Char = self.Text.Text:utf8sub(i, i)
					
					if Char ~= "\n" then
						
						Char = "*"
						
					end
					
					local Font = Format.Font or self.Text.Font
					local CharWidth = Font:getWidth(Char)
					
					Offset = Offset + CharWidth
				end
				
			else
				
				for i = 1, Min - 1 do
					
					local Format = self.Text.Format[i] or self.Text
					local Char = self.Text.Text:utf8sub(i, i)
					
					local Font = Format.Font or self.Text.Font
					local CharWidth = Font:getWidth(Char)
					
					Offset = Offset + CharWidth
					
				end
				
			end
			
			local Length = 0
			
			if self.Text.Password then
				
				for i = Min, Max - 1 do
					
					local Format = self.Text.Format[i] or self.Text
					local Char = self.Text.Text:utf8sub(i, i)
					
					if Char ~= "\n" then
						Char = "*"
					end
					
					local Font = Format.Font or self.Text.Font
					local CharWidth = Font:getWidth(Char)
					
					Length = Length + CharWidth
					
				end
				
			else
				
				for i = Min, Max - 1 do
					
					local Format = self.Text.Format[i] or self.Text
					local Char = self.Text.Text:utf8sub(i, i)
					
					local Font = Format.Font or self.Text.Font
					local CharWidth = Font:getWidth(Char)
					
					Length = Length + CharWidth
					
				end
				
			end
			
			love.graphics.setColor(80, 150, 250, 80)
			love.graphics.rectangle("fill", Offset, math.floor((self:GetHeight() - self.Text:getHeight())/2), Length, self.Text:getHeight())
			
		elseif self.IsTop then
			
			local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
			local Offset = 5 - self.Layout.Offset
			
			if self.Text.Password then
				
				for i = 1, Min - 1 do
					
					local Format = self.Text.Format[i] or self.Text
					local Char = self.Text.Text:utf8sub(i, i)
					
					if Char ~= "\n" then
						Char = "*"
					end
					
					local Font = Format.Font or self.Text.Font
					local CharWidth = Font:getWidth(Char)
					
					Offset = Offset + CharWidth
					
				end
				
			else
				
				for i = 1, Min - 1 do
					
					local Format = self.Text.Format[i] or self.Text
					local Char = self.Text.Text:utf8sub(i, i)
					
					local Font = Format.Font or self.Text.Font
					local CharWidth = Font:getWidth(Char)
					
					Offset = Offset + CharWidth
					
				end
				
			end
			
			love.graphics.setColor(100, 100, 100, 255)
			love.graphics.setFont(self.Text.Font)
			love.graphics.print("|", Offset, math.floor(self:GetHeight() - self.Text.Font:getHeight())/2)
			
		end
		
	elseif #self.HintText.Text > 0 then
		
		self.HintText:Draw(5, (self:GetHeight() - self.HintText:getHeight())/2)
		
	end
	
end