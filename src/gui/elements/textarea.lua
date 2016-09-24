local gui = ...
local Element = gui.register("TextArea", "Container")

Element.Selected = 1
Element.SelectedLength = 0

Element.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Element.TextColor = {80, 80, 80, 255}
Element.BackgroundColor = {255, 255, 255, 255}
Element.BorderColor = {80, 80, 80, 255}

local function SliderValue(Slider)
	Slider.Parent.Changed = true
end

function Element:Create(x, y, Width, Height, Parent)
	
	Parent = Parent or gui.Desktop

	self:SetParent(Parent)
	self:SetPosition(x, y)
	self:SetDimensions(Width, Height)
	self:SetText()
	self:Init()
	
	return self
	
end

function Element:Init()
	
	Element.Base.Init(self)
	
	local Width, Height = self:GetDimensions()
	
	self.Layout.TextFont = Element.TextFont
	self.Layout.TextColor = Element.TextColor
	self.Layout.BackgroundColor = Element.BackgroundColor
	self.Layout.BorderColor = Element.BorderColor
	
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))

	self.Layout.VSlider = gui.create("VSlider", 0, 0, 15, Height - 14, self)
	self.Layout.VSlider.OnValue = SliderValue
	
	self.Layout.HSlider = gui.create("HSlider", 0, 0, Width - 14, 15, self)
	self.Layout.HSlider.OnValue = SliderValue
	
end

function Element:MoveLeft(Offset)
	
	-- Callback
	
end

function Element:MoveRight(Offset)
	
	-- Callback
	
end

function Element:Filter(Text, Position, Length, Line)
	
	--Callback
	return true
	
end

function Element:CanDelete(Position, Length, Line)
	
	-- Callback
	return true
	
end

function Element:TextInput(Text)
	
	if not self.Disabled then
		
		self:Write(Text)
		
	end
	
	Element.Base.TextInput(self, Text)
	
end

function Element:KeyPressed(Key, ScanCode, IsRepeat, ...)
	
	Element.Base.KeyPressed(self, Key, ScanCode, IsRepeat, ...)
	
	if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
		
		if Key == "v" then
			
			-- Paste
			self:TextInput(love.system.getClipboardText())
			
		elseif Key == "c" then
			
			if not self.Text.Password then
				
				-- Copy
				love.system.setClipboardText(self:GetSelectedText())
				
			end
			
		elseif Key == "a" then
			
			-- Select all
			self.Selected = 1
			self.SelectedLength = self.Text.Text:utf8len()
			self.Changed = true
			
		end
		
	elseif Key == "return" then
		
		-- New line
		self:TextInput("\n")
		
	elseif Key == "backspace" then
		
		if not self.Disabled then
		
			-- Delete
			if self.SelectedLength == 0 then
				
				-- Delete selected text
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
				
				-- Delete from current position to the left
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
			
		end
		
	elseif Key == "delete" then
			
		if not self.Disabled then
			
			-- Delete
			if self.SelectedLength == 0 then
				
				-- Delete from current position to the right
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
				
				-- Delete selected text
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
			
		end
		
	elseif Key == "left" then
		
		-- Move to the left
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
			
			-- Shift pressed? select shorter string
			self.SelectedLength = self.SelectedLength - 1
			
			if self.SelectedLength <= 0 then
				
				if self.Selected + self.SelectedLength < 1 then
					
					self.SelectedLength = 1 - self.Selected
					
				end
				
			end
			
		else
			
			local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
			
			-- If there's a selected text, unselect it
			if self.SelectedLength ~= 0 then
				
				if Min > 0 then
					
					self.Selected = Min
					
				end
				
				self.SelectedLength = 0
				
			else
				
				-- Move to the left
				self.Selected = math.max(Min - 1, 1)
				
			end
			
		end
		
		self:UpdateText()
		
	elseif Key == "right" then
		
		-- Move to the right
		
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
			
			-- Select a longer string to the right
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

function Element:FindTopElement()
	
	if not self.Hidden then
		
		-- Make it not return the sliders, otherwise 'TextInput' will send text to them
		return self
		
	end
	
end

function Element:Write(Text)
	
	-- Directly receive text from the text input
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
	
	if Write then
		
		for _, Line in pairs(self.Text.Line) do
			
			if Line.Start < self.Selected and Line.Start + Line.Text:utf8len() >= self.Selected then
				
				local Min = math.min(math.min(self.Selected, self.Selected + self.SelectedLength) - Line.Start, Line.Text:utf8len()) + Line.Start
				local WidthOffset = 15
				
				for i = Line.Start, Min - 1 do
					
					local Format = self.Text.Format[i] or self.Text
					local Char = self.Text.Text:utf8sub(i, i)
					
					local Font = Format.Font or self.Text.Font
					local CharWidth = Font:getWidth(Char)
					
					WidthOffset = WidthOffset + CharWidth
					
				end
				
				if WidthOffset < self:GetWidth() then
					
					WidthOffset = 0
					
				end
				
				-- Update slider dimensions
				self.Layout.VSlider:SetValue(Line.Altitude + Line.Height)
				self.Layout.HSlider:SetValue(WidthOffset)
				self.Changed = true
				break
				
			end
			
		end
		
	end
	
	self.Changed = true
end

function Element:WheelMoved(x, y, ...)
	
	Element.Base.WheelMoved(self, x, y, ...)
	self.Layout.VSlider:SetValue(self.Layout.VSlider.Value - y * 15)
	self.Changed = true
	
end

function Element:GetMousePosition(x, y)
	
	return self.Text:GetPosition(
		x + self.Layout.HSlider.Value * (self.Layout.HSlider.Max - self:GetWidth()) / self.Layout.HSlider.Max,
		y + self.Layout.VSlider.Value * (self.Layout.VSlider.Max - self:GetHeight()) / self.Layout.VSlider.Max
	)
	
end

function Element:MousePressed(x, y, Button, IsTouch, ...)
	
	Element.Base.MousePressed(self, x, y, Button, IsTouch, ...)
	
	if Button == 1 then
		
		if Button == 1 then
			
			self.Selected = self:GetMousePosition(x, y)
			self.SelectedLength = 0
			self.Changed = true
			
		end
		
	end
	
end

function Element:MouseDrag(x, y, dx, dy)
	
	Element.Base.MouseDrag(self, x, y, dx, dy)
	
	self.SelectedLength = self:GetMousePosition(x, y) - self.Selected
	self.Changed = true
	
end

function Element:MakePopup()
	
	self.Base.MakePopup(self)
	self.Changed = true
	
end

function Element:MakePulldown()
	
	self.Base.MakePulldown(self)
	self.Changed = true
	
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

function Element:Update(...)
	
	Element.Base.Update(self, ...)
	
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

function Element:UpdateLayout()
	
	local Width, Height = self:GetDimensions()
	
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
	
	self.Layout.VSlider:SetPosition(Width - 15, 0)
	self.Layout.VSlider:SetDimensions(15, Height - 14)
	
	self.Layout.HSlider:SetPosition(0, Height - 15)
	self.Layout.HSlider:SetDimensions(Width - 14, 15)
	
	self.Layout.HSlider:SetMin(Width)
	self.Layout.HSlider:SetMax(self.Text:getWidth() + 15)
	self.Layout.HSlider.Hidden = self.Layout.HSlider.Min >= self.Layout.HSlider.Max
	
	self.Layout.VSlider:SetMin(Height)
	self.Layout.VSlider:SetMax(self.Text:getHeight() + 15)
	self.Layout.VSlider.Hidden = self.Layout.VSlider.Min >= self.Layout.VSlider.Max
	
end

function Element:RenderSkin()
	
	local Width, Height = self:GetDimensions()
	
	love.graphics.setColor(self.Layout.BorderColor)
	love.graphics.rectangle("line", 1, 1, Width - 2, Height - 2)
	
	love.graphics.setColor(self.Layout.BackgroundColor)
	love.graphics.rectangle("fill", 1, 1, Width - 2, Height - 2)
	
	if self.Text.Text:utf8len() > 0 or self.IsTop then
		
		local WidthOffset = -self.Layout.HSlider.Value * (self.Layout.HSlider.Max - Width) / self.Layout.HSlider.Max + 5
		local HeightOffset = -self.Layout.VSlider.Value * (self.Layout.VSlider.Max - Height) / self.Layout.VSlider.Max
		
		self.Text:DrawOffset(WidthOffset, HeightOffset, HeightOffset, Height)
		
		if self.SelectedLength ~= 0 then
			
			local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
			local Max = math.max(self.Selected, self.Selected + self.SelectedLength)
			local HeightOffset = HeightOffset
			
			for _, Line in pairs(self.Text.Line) do
				
				if Min <= Line.Start + Line.Text:utf8len() then
					
					local Min = math.max(Min, Line.Start)
					local Min2 = math.min(Min - Line.Start, Line.Text:utf8len()) + Line.Start
					local Max2 = math.min(Max - Line.Start, Line.Text:utf8len()) + Line.Start
					local WidthOffset = WidthOffset
					
					for i = Line.Start, Min2 - 1 do
						
						local Format = self.Text.Format[i] or self.Text
						local Char = self.Text.Text:utf8sub(i, i)
						
						local Font = Format.Font or self.Text.Font
						local CharWidth = Font:getWidth(Char)
						
						WidthOffset = WidthOffset + CharWidth
						
					end
					
					local Length = 0
					
					for i = Min2, Max2 - 1 do
						
						local Format = self.Text.Format[i] or self.Text
						local Char = self.Text.Text:utf8sub(i, i)
						
						local Font = Format.Font or self.Text.Font
						local CharWidth = Font:getWidth(Char)
						
						Length = Length + CharWidth
						
					end
					
					love.graphics.setColor(80, 150, 250, 80)
					love.graphics.rectangle("fill", WidthOffset, HeightOffset, Length, Line.Height)
					
				elseif Max < Line.Start + Line.Text:utf8len() then
					
					break
					
				end
				
				HeightOffset = HeightOffset + Line.Height
				
			end
			
		elseif self.IsTop then
			
			local Min = math.min(self.Selected, self.Selected + self.SelectedLength)
			local HeightOffset = HeightOffset
			
			for _, Line in pairs(self.Text.Line) do
				
				if Min >= Line.Start and Min <= Line.Start + Line.Text:utf8len() then
					
					local WidthOffset = WidthOffset
					local Max = math.min(Min - Line.Start, Line.Text:utf8len()) + Line.Start
					
					for i = Line.Start, Max - 1 do
						
						local Format = self.Text.Format[i] or self.Text
						local Char = self.Text.Text:utf8sub(i, i)
						
						local Font = Format.Font or self.Text.Font
						local CharWidth = Font:getWidth(Char)
						
						WidthOffset = WidthOffset + CharWidth
						
					end

					love.graphics.setColor(100, 100, 100, 255)
					love.graphics.setFont(self.Text.Font)
					love.graphics.print("|", WidthOffset, HeightOffset)
					break
					
				end
				
				HeightOffset = HeightOffset + Line.Height
				
			end
			
		end
		
	end
	
end