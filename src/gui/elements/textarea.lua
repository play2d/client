local gui = ...
local Element = gui.register("TextArea", "Container")

Element.Selected = 1
Element.SelectedLength = 0

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetText()
	self:Init()
	
	return self
	
end

function Element:Filter(Text, Position, Length, Line)
	
	return true
	
end

function Element:CanDelete(Position, Length, Line)
	return true
end

function Element:TextInput(Text)
	if not self.Disabled then
		self:Write(Text)
	end
	self.Base.TextInput(self, Text)
end

function Element:KeyPressed(Key, ScanCode, IsRepeat)
	if not self.Disabled then
		if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
			if Key == "v" then
				self:TextInput(love.system.getClipboardText())
			elseif Key == "c" then
				if not self.Text.Password then
					love.system.setClipboardText(self:GetSelectedText())
				end
			elseif Key == "a" then
				self.Selected = 1
				self.SelectedLength = self.Text.Text:utf8len()
				self.Changed = true
			end
		elseif Key == "return" then
			self:TextInput("\n")
		elseif Key == "backspace" then
			if self.SelectedLength == 0 then
				local Min = self.Selected - 1
				local Max = self.Selected
				local LinePosition = 1
				for Index, Line in pairs(self.Text.Line) do
					if Line.Start <= Min then
						LinePosition = Index
					else
						break
					end
				end
				
				if self:CanDelete(Min, Max - Min, LinePosition) then
					self.Text:SetText(self.Text.Text:utf8sub(1, self.Selected - 2) .. self.Text.Text:utf8sub(self.Selected))
					self.Selected = math.max(self.Selected - 1, 1)
				end
			else
				local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
				local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
				for Index, Line in pairs(self.Text.Line) do
					if Line.Start <= Min then
						LinePosition = Index
					else
						break
					end
				end
				
				if self:CanDelete(Min, Max - Min, LinePosition) then
					self.Text:SetText(self.Text.Text:utf8sub(1, Min - 1) .. self.Text.Text:utf8sub(Max))
				
					self.Selected = math.max(Min, 1)
					self.SelectedLength = 0
				end
			end
			self:UpdateText(true)
		elseif Key == "delete" then
			if self.SelectedLength == 0 then
				local Min = self.Selected
				local Max = self.Selected + 1
				local LinePosition = 0
				for Index, Line in pairs(self.Text.Line) do
					if Line.Start <= Min then
						LinePosition = Index
					else
						break
					end
				end
				
				if self:CanDelete(Min, Max - Min, LinePosition) then
					self.Text:SetText(self.Text.Text:utf8sub(1, self.Selected - 1) .. self.Text.Text:utf8sub(self.Selected + 1))
				end
			else
				local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
				local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
				local LinePosition = 0
				for Index, Line in pairs(self.Text.Line) do
					if Line.Start <= Min then
						LinePosition = Index
					else
						break
					end
				end
				
				if self:CanDelete(Min, Max - Min, LinePosition) then
					self.Text:SetText(self.Text.Text:utf8sub(1, Min - 1) .. self.Text.Text:utf8sub(Max))
					
					self.Selected = math.max(Min, 1)
					self.SelectedLength = 0
				end
			end
			self:UpdateText(true)
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
	self.Base.KeyPressed(self, Key, ScanCode, IsRepeat)
end

function Element:FindTopElement()
	if not self.Hidden then
		return self
	end
end

function Element:Write(Text)
	local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
	local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
	local LinePosition = 1
	for Index, Line in pairs(self.Text.Line) do
		if Line.Start <= Min then
			LinePosition = Index
		else
			break
		end
	end
	
	if (Max - Min == 0 or self:CanDelete(Min, Max - Min, LinePosition)) and self:Filter(Text, Min, Max - Min, LinePosition) then
		self.Text:SetText(self.Text.Text:utf8sub(1, Min - 1) .. Text .. self.Text.Text:utf8sub(Max))
		
		self.Selected = math.max(Min + Text:utf8len(), 1)
		self.SelectedLength = 0
		self:UpdateText(true)
	end
end

function Element:SetText(Text)
	self.Base.SetText(self, Text)
	self:UpdateText()
end

function Element:UpdateText(Write)
	local Skin = self:GetSkin()
	if Skin.UpdateText then
		Skin.UpdateText(self, Write)
	end
	self.Changed = true
end

function Element:GetMousePosition(x, y)
	local Skin = self:GetSkin()
	if Skin.GetMousePosition then
		return Skin.GetMousePosition(self, x, y)
	end
	return self.Text:GetPosition(x, y)
end

function Element:MousePressed(x, y, Button, IsTouch)
	if Button == 1 and not self.Disabled then
		if Button == 1 then
			self.Selected = self:GetMousePosition(x, y)
			self.SelectedLength = 0
			self.Changed = true
		end
	end
	self.Base.MousePressed(self, x, y, Button, IsTouch)
end

function Element:MouseDrag(x, y, dx, dy)
	if not self.Disabled then
		self.SelectedLength = self:GetMousePosition(x, y) - self.Selected
		self.Changed = true
	end
	self.Base.MouseDrag(self, x, y, dx, dy)
end

function Element:MakePopup()
	self.Base.MakePopup(self)
	if gui.Mobile then
		love.keyboard.setTextInput(true)
	end
end

function Element:MakePulldown()
	self.Base.MakePulldown(self)
	if gui.Mobile then
		love.keyboard.setTextInput(false)
	end
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
	local Skin = self:GetSkin()
	if Skin.MoveLeft then
		Skin.MoveLeft(self, Offset)
	end
end

function Element:MoveRight(Offset)
	local Skin = self:GetSkin()
	if Skin.MoveRight then
		Skin.MoveRight(self, Offset)
	end
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
end

function Element:SetFormat(Position, Length, Font, R, G, B, A)
	self.Text:SetFormat(Position, Length, Font, R, G, B, A)
end