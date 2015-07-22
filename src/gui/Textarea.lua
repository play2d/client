local TTextarea = {}
local TTextareaMetatable = {__index = TTextarea}
TTextarea.Type = "Textarea"
TTextarea.Text = ""
TTextarea.Start = 0
TTextarea.Length = 0
setmetatable(TTextarea, gui.TGadgetMetatable)

function gui.CreateTextarea(x, y, Width, Height, Parent)
	local Textarea = TTextarea.New()
	if Parent:AddGadget(Textarea) then
		Textarea:SetPosition(x, y)
		Textarea:SetSize(Width, Height)
		return Textarea:Init()
	end
end

function TTextarea.New()
	return setmetatable({}, TTextareaMetatable)
end

function TTextarea:Init()
	self.Format = {}
	self.Line = {}
	self.Slider = {}
	self.Slider.Vertical = gui.CreateSlider(gui.SLIDER_VER, self:Width() - 13, 1, 12, self:Height() - 15, self, 1, 1)
	self.Slider.Horizontal = gui.CreateSlider(gui.SLIDER_HOR, 1, self:Height() - 13, self:Width() - 15, 12, self, 1, 1)
	self.Slider.Vertical.Hidden = true
	self.Slider.Horizontal.Hidden = true
	return self
end

function TTextarea:AddGadget(Gadget)
	if Gadget.Heading == gui.SLIDER_VER then
		if not self.Slider.Vertical then
			Gadget.ID = 1
			Gadget.Parent = self
			Gadget.Theme = self.Theme
			return true
		end
	elseif Gadget.Heading == gui.SLIDER_HOR then
		if not self.Slider.Horizontal then
			Gadget.ID = 2
			Gadget.Parent = self
			Gadget.Theme = self.Theme
			return true
		end
	end
end

function TTextarea:HoverGadget()
	if not self.Hidden then
		local HoverGadget = self.Slider.Vertical:HoverGadget() or self.Slider.Horizontal:HoverGadget()
		if HoverGadget then
			return HoverGadget
		elseif self:MouseHover() then
			return self
		end
	end
end

function TTextarea:SetSize(Width, Height)
	self.Size = {Width = Width, Height = Height}
	if self.Slider then
		self.Slider.Vertical:SetPosition(Width - 13, 1)
		self.Slider.Vertical:SetSize(12, Height - 15)
		self.Slider.Vertical.Values.Count = Height - 13
		self.Slider.Vertical.Hidden = self.Slider.Vertical.Values.Max < self.Slider.Vertical.Values.Count
		
		self.Slider.Horizontal:SetPosition(1, Height - 13)
		self.Slider.Horizontal:SetSize(Width - 15, 12)
		self.Slider.Horizontal.Values.Count = Width - 13
		self.Slider.Horizontal.Hidden = self.Slider.Horizontal.Values.Max < self.Slider.Horizontal.Values.Count
	end
end

function TTextarea:CalculateLines()
	self.Line = {}
	local TextPosition = 0
	local Width, Height = self:Width(), self:Height()
	for Format in self:EachFormat() do
		local Line = self.Line[Format.Line]
		if Line then
			Line.Width = Line.Width + Format.Width
			if Format.Height > Line.Height then
				Line.Height = Format.Height
			end
		else
			Line = {
				Width = Format.Width,
				Height = Format.Height,
				CumulativeHeight = Format.Height,
				Start = Format.Start,
			}
			if self.Line[Format.Line - 1] then
				Line.CumulativeHeight = self.Line[Format.Line - 1].CumulativeHeight + Format.Height
			end
			self.Line[Format.Line] = Line
		end
		if Format.LineBreak then
			TextPosition = TextPosition + 1
		end
		if self.Start + self.Length >= TextPosition and self.Start + self.Length <= TextPosition + #Format.Text then
			if Line.Width > Width then
				self.Slider.Horizontal.Value = Line.Width + 13
			end
			if Line.CumulativeHeight > Height then
				self.Slider.Vertical.Value = Line.CumulativeHeight + 13
			end
		end
		TextPosition = TextPosition + #Format.Text
	end
	
	self.Slider.Vertical.Values.Count = self:Height() - 13
	self.Slider.Horizontal.Values.Count = self:Width() - 13
	self.Slider.Vertical.Values.Max = 0
	self.Slider.Horizontal.Values.Max = 0
	for LineID, Line in pairs(self.Line) do
		self.Slider.Vertical.Values.Max = self.Slider.Vertical.Values.Max + Line.Height
		self.Slider.Vertical.Hidden = self.Slider.Vertical.Values.Max < self.Slider.Vertical.Values.Count
		if Line.Width + 13 > self.Slider.Horizontal.Values.Max then
			self.Slider.Horizontal.Values.Max = Line.Width + 13
			self.Slider.Horizontal.Hidden = self.Slider.Horizontal.Values.Max < self.Slider.Horizontal.Values.Count
		end
	end
	self.Slider.Vertical.Values.Max = self.Slider.Vertical.Values.Max + 13
end

function TTextarea:SetText(Text)
	self.Text = Text
	self:CalculateLines()
end

function TTextarea:SetFormat(Start, Length, Font, R, G, B, A)
	local FormatI, Format
	repeat
		local NextI, NextFormat = next(self.Format, FormatI)
		if not NextFormat or NextFormat.Start > Start then
			-- Find the closest format before this one we're creating
			break
		end
		FormatI = NextI
		Format = NextFormat
	until true
	if Format and Format.Start + Format.Length > Start then
		-- Reduce the length of the previous format
		Format.Length = Start - Format.Start
	end
	FormatI, Format = next(self.Format, FormatI)
	if Format and Format.Start < Start + Length then
		-- Reduce the length of the next format
		Format.Length = Format.Start + Format.Length - (Start + Length)
		-- Increase the position of the next format
		Format.Start = Start + Length
		self.Format[FormatI] = nil
		if Format.Length > 0 then
			table.insert(self.Format, Format)
		end
	end
	table.insert(self.Format,
		{
			Start = Start,
			Length = Length,
			Font = Font,
			Color = {R, G, B, A}
		}
	)
	table.sort(self.Format,
		function (A, B)
			return A.Start < B.Start
		end
	)
	self:CalculateLines()
end

-- This function is magic, it iterates through formats/non-formatted text/line breaks
function TTextarea:EachFormat()
	local DefaultFormat = {
		Font = self:GetFont(),
		Color = self:GetTheme().Text,
	}
	local Index, Format
	local Line = 1
	return function ()
		if Format then
			local NextLine = next(Format.TextArray, Format.TextIndex)
			if NextLine then
				-- This part iterates to the next line break
				Line = Line + 1
				
				Format.TextArray[Format.TextIndex] = nil
				Format.TextIndex = NextLine
				Format.Text = Format.TextArray[NextLine]
				Format.Width = Format.Font:getWidth(Format.Text)
				Format.Height = Format.Font:getHeight()
				Format.LineBreak = true
				Format.Line = Line
				Format.First = nil
				
				-- Next line exists, push!
				return Format
			else
				Format.LineBreak = nil
			end
				
			if Format.Start + Format.Length - 1 >= #self.Text then
				-- The last format returned all we had left, what are you expecting for?
				return nil
			end
			
			local NextIndex, NextFormat = next(self.Format, Index)
			if NextFormat == nil then
				-- Yea we sent the last format, but we didn't send everything
				DefaultFormat.Start = Format.Start + Format.Length
				DefaultFormat.Length = math.max(#self.Text - DefaultFormat.Start + 1, 0)
				Format = DefaultFormat
				Format.First = nil
			elseif NextFormat.Start == Format.Start + Format.Length or Format == DefaultFormat then
				-- Oh, it looks like the next format starts just after this one ends, let's just send it
				Index = NextIndex
				Format = NextFormat
				Format.First = nil
			else
				-- So, there's a string that is not formatted between the last format and the next one
				DefaultFormat.Start = Format.Start + Format.Length
				DefaultFormat.Length = NextFormat.Start - DefaultFormat.Start - 1
				Format = DefaultFormat
				Format.First = nil
			end
		else
			local NextIndex, NextFormat = next(self.Format)
			if NextFormat then
				-- Yea it looks like the textarea is formatted
				if NextFormat.Start == 1 then
					-- That's nice, the format starts at the begining of the textarea
					Index = 1
					Format = NextFormat
					Format.First = true
				else
					-- We need to send the string between the begining of the textarea and the next format
					DefaultFormat.Start = 1
					DefaultFormat.Length = NextFormat.Start - 1
					Format = DefaultFormat
					Format.First = true
				end
			else
				-- We didn't set any format to this textarea? cool, less cpu usage!
				DefaultFormat.Start = 1
				DefaultFormat.Length = #self.Text
				Format = DefaultFormat
				Format.First = true
			end
		end
		
		-- This part splits the text into lines, and returns the first line
		local Text = self.Text:sub(Format.Start, Format.Start + Format.Length - 1)
		Format.TextArray = {}
		repeat
			local Match, Position = Text:match("([^\n]*)()")
			table.insert(Format.TextArray, Match)
			Text = Text:sub(Position + 1)
		until #Text == 0
		Format.TextIndex, Format.Text = next(Format.TextArray)
		Format.Width = Format.Font:getWidth(Format.Text)
		Format.Height = Format.Font:getHeight()
		Format.Line = Line
		
		-- Format complete! push!!
		return Format
	end
end

function TTextarea:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:Width(), self:Height()
		local Theme = self:GetTheme()
		
		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.SliderArea))
		love.graphics.rectangle("fill", x, y, Width, Height)
		
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)
		
		love.graphics.setScissor(x, y, Width - 13, Height - 13)
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 15, Height - 15)
		
		local TextPosition = 0
		local WidthOffset = 2.5 - self.Slider.Horizontal.Value * (self.Slider.Horizontal.Values.Max - Width + 5) / (self.Slider.Horizontal.Values.Max)
		local HeightOffset = 2.5 - self.Slider.Vertical.Value * (self.Slider.Vertical.Values.Max - Height + 5) / (self.Slider.Vertical.Values.Max)
		for Format in self:EachFormat() do
			love.graphics.setFont(Format.Font)
			love.graphics.setColor(unpack(Format.Color))
			
			if Format.LineBreak then
				TextPosition = TextPosition + 1
				WidthOffset = 2.5 - self.Slider.Horizontal.Value * (self.Slider.Horizontal.Values.Max - Width + 5) / (self.Slider.Horizontal.Values.Max)
				HeightOffset = HeightOffset + self.Line[Format.Line].Height
			end
			love.graphics.print(Format.Text, x + WidthOffset, y + HeightOffset + self.Line[Format.Line].Height - Format.Height)
			
			if self.Length > 0 and TextPosition + #Format.Text >= self.Start then
				love.graphics.setColor(unpack(Theme.SelectedText))
				love.graphics.rectangle("fill",
					x + WidthOffset + Format.Font:getWidth(Format.Text:sub(1, math.max(self.Start - TextPosition, 0))),
					y + HeightOffset + self.Line[Format.Line].Height - Format.Height,
					Format.Font:getWidth(Format.Text:sub(math.max(self.Start - TextPosition + 1, 0), math.max(self.Start + self.Length - TextPosition, 0))),
					Format.Height
				)
			elseif self.Length < 0 and TextPosition + #Format.Text >= self.Start + self.Length then
				love.graphics.setColor(unpack(Theme.SelectedText))
				love.graphics.rectangle("fill",
					x + WidthOffset + Format.Font:getWidth(Format.Text:sub(1, math.max(self.Start + self.Length - TextPosition, 0))),
					y + HeightOffset + self.Line[Format.Line].Height - Format.Height,
					Format.Font:getWidth(Format.Text:sub(math.max(self.Start + self.Length - TextPosition + 1, 0), math.max(self.Start - TextPosition, 0))),
					Format.Height
				)
			elseif self.Length == 0 and self.Start > TextPosition and self.Start <= TextPosition + #Format.Text then
				love.graphics.setColor(unpack(Format.Color))
				love.graphics.print("|",
					x + WidthOffset + Format.Font:getWidth(Format.Text:sub(1, math.max(self.Start - TextPosition, 0))) - 2.5,
					y + HeightOffset + self.Line[Format.Line].Height - Format.Height
				)
			end
			TextPosition = TextPosition + #Format.Text
			WidthOffset = WidthOffset + Format.Width
		end
		
		self.Slider.Vertical:Render(dt)
		self.Slider.Horizontal:Render(dt)
	end
end

function TTextarea:MouseClicked(x, y)
	if not self.Hidden and not self.Disabled then
		self.Dropped = nil
		self.Grabbed = {x = x - self:x(), y = y - self:y()}
		self:OnClick(self.Grabbed.x, self.Grabbed.y)
		self:SetHoverAll()

		local Width, Height = self:Width(), self:Height()
		local TextPosition = 0
		local WidthOffset = 2.5 - self.Slider.Horizontal.Value * (self.Slider.Horizontal.Values.Max - Width + 5) / (self.Slider.Horizontal.Values.Max)
		local HeightOffset = 2.5 - self.Slider.Vertical.Value * (self.Slider.Vertical.Values.Max - Height + 5) / (self.Slider.Vertical.Values.Max)
		for Format in self:EachFormat() do
			if Format.LineBreak then
				TextPosition = TextPosition + 1
				WidthOffset = 2.5 - self.Slider.Horizontal.Value * (self.Slider.Horizontal.Values.Max - Width + 5) / (self.Slider.Horizontal.Values.Max)
				HeightOffset = HeightOffset + self.Line[Format.Line].Height
			end
			if self.Grabbed.y >= HeightOffset and self.Grabbed.y <= HeightOffset + self.Line[Format.Line].Height then
				if self.Grabbed.x > WidthOffset and self.Grabbed.x <= WidthOffset + Format.Width then
					local TextWidth = WidthOffset
					for i = 1, #Format.Text do
						local CharWidth = Format.Font:getWidth(Format.Text:sub(i, i))
						if self.Grabbed.x > TextWidth and self.Grabbed.x <= TextWidth + CharWidth then
							self.Start = TextPosition + i
							self.Length = 0
							break
						end
						TextWidth = TextWidth + CharWidth
					end
				elseif self.Grabbed.x > self.Line[Format.Line].Width then
					self.Start = TextPosition + #Format.Text
					self.Length = 0
				elseif self.Grabbed.x < 0 then
					if Format.LineBreak or Format.First then
						self.Start = TextPosition
						self.Length = 0
					end
				end
			end
			TextPosition = TextPosition + #Format.Text
			WidthOffset = WidthOffset + Format.Width
		end
	end
end

function TTextarea:MouseMove(x, y)
	if not self.Hidden and not self.Disabled then
		local Position = {x = x - self:x(), y = y - self:y()}
		local Width, Height = self:Width(), self:Height()
		local TextPosition = 0
		local WidthOffset = 2.5 - self.Slider.Horizontal.Value * (self.Slider.Horizontal.Values.Max - Width + 5) / (self.Slider.Horizontal.Values.Max)
		local HeightOffset = 2.5 - self.Slider.Vertical.Value * (self.Slider.Vertical.Values.Max - Height + 5) / (self.Slider.Vertical.Values.Max)
		for Format in self:EachFormat() do
			if Format.LineBreak then
				TextPosition = TextPosition + 1
				WidthOffset = 2.5 - self.Slider.Horizontal.Value * (self.Slider.Horizontal.Values.Max - Width + 5) / (self.Slider.Horizontal.Values.Max)
				HeightOffset = HeightOffset + self.Line[Format.Line].Height
			end
			if Position.y >= HeightOffset and Position.y <= HeightOffset + self.Line[Format.Line].Height then
				if Position.x > WidthOffset and Position.x <= WidthOffset + Format.Width then
					local TextWidth = WidthOffset
					for i = 1, #Format.Text do
						local CharWidth = Format.Font:getWidth(Format.Text:sub(i, i))
						if Position.x > TextWidth and Position.x <= TextWidth + CharWidth then
							self.Length = TextPosition + i - self.Start
							break
						end
						TextWidth = TextWidth + CharWidth
					end
				elseif Position.x > self.Line[Format.Line].Width then
					self.Length = (TextPosition + #Format.Text) - self.Start
				elseif Position.x < 0 then
					if Format.LineBreak or Format.First then
						self.Length = TextPosition - self.Start
					end
				end
			end
			TextPosition = TextPosition + #Format.Text
			WidthOffset = WidthOffset + Format.Width
		end
	end
end

function TTextarea:Update(dt)
	if not self.Hidden and not self.Disabled then
		if self.Grabbed then
			local x = love.mouse.getX() - self:x()
			local y = love.mouse.getY() - self:y()
			local Width, Height = self:Width() - 13, self:Height() - 13
			if not self.Slider.Horizontal.Hidden then
				if x > Width then
					if self.Slider.Horizontal.Value < self.Slider.Horizontal.Values.Max then
						self.Slider.Horizontal.Value = math.min(self.Slider.Horizontal.Value + (x - Width) * dt / 170, self.Slider.Horizontal.Values.Max)
					end
				elseif x < 0 then
					if self.Slider.Horizontal.Value > 0 then
						self.Slider.Horizontal.Value = math.max(self.Slider.Horizontal.Value + x * dt / 170, 0)
					end
				end
			end
			if not self.Slider.Vertical.Hidden then
				if y > Height then
					if self.Slider.Vertical.Value < self.Slider.Vertical.Values.Max then
						self.Slider.Vertical.Value = math.min(self.Slider.Vertical.Value + (y - Height) * dt / 170, self.Slider.Vertical.Values.Max)
					end
				elseif y < 0 then
					if self.Slider.Vertical.Value > 0 then
						self.Slider.Vertical.Value = math.max(self.Slider.Vertical.Value + y * dt / 170, 0)
					end
				end
			end
		end
	end
end

function TTextarea:MouseDropped(x, y)
	if not self.Hidden and not self.Disabled then
		if self.Grabbed then
			self.Grabbed = nil
			self.Dropped = {x = x - self:x(), y = y - self:y()}
			self:OnDrop(self.Dropped.x, self.Dropped.y)

			local Width, Height = self:Width(), self:Height()
			local TextPosition = 0
			local WidthOffset = 2.5 - self.Slider.Horizontal.Value * (self.Slider.Horizontal.Values.Max - Width + 5) / (self.Slider.Horizontal.Values.Max)
			local HeightOffset = 2.5 - self.Slider.Vertical.Value * (self.Slider.Vertical.Values.Max - Height + 5) / (self.Slider.Vertical.Values.Max)
			for Format in self:EachFormat() do
				if Format.LineBreak then
					TextPosition = TextPosition + 1
					WidthOffset = 2.5 - self.Slider.Horizontal.Value * (self.Slider.Horizontal.Values.Max - Width + 5) / (self.Slider.Horizontal.Values.Max)
					HeightOffset = HeightOffset + self.Line[Format.Line].Height
				end
				if self.Dropped.y >= HeightOffset and self.Dropped.y <= HeightOffset + self.Line[Format.Line].Height then
					if self.Dropped.x > WidthOffset and self.Dropped.x <= WidthOffset + Format.Width then
						local TextWidth = WidthOffset
						for i = 1, #Format.Text do
							local CharWidth = Format.Font:getWidth(Format.Text:sub(i, i))
							if self.Dropped.x > TextWidth and self.Dropped.x <= TextWidth + CharWidth then
								self.Length = TextPosition + i - self.Start
								break
							end
							TextWidth = TextWidth + CharWidth
						end
					elseif self.Dropped.x > self.Line[Format.Line].Width then
						self.Length = (TextPosition + #Format.Text) - self.Start
					elseif self.Dropped.x < 0 then
						if Format.LineBreak or Format.First then
							self.Length = TextPosition - self.Start
						end
					end
				end
				TextPosition = TextPosition + #Format.Text
				WidthOffset = WidthOffset + Format.Width
			end
		end
	end
end

function TTextarea:Write(Text)
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
		self:CalculateLines()
	end
end

function TTextarea:keypressed(key)
	if self.Hidden or self.Disabled then
		return nil
	end

	local Length = #self.Text
	if key == "backspace" then
		if self.Length == 0 then
			self.Text = self.Text:sub(1, self.Start - 1) .. self.Text:sub(self.Start + 1)
			self.Start = math.max(self.Start - 1, 0)
		elseif self.Length > 0 then
			self.Text = self.Text:sub(1, self.Start) .. self.Text:sub(self.Start + self.Length + 1)
			self.Length = 0
		else
			self.Text = self.Text:sub(1, self.Start + self.Length) .. self.Text:sub(self.Start + 1)
			self.Start = math.max(self.Start + self.Length, 0)
			self.Length = 0
		end
		self:CalculateLines()
	elseif key == "delete" then
		if self.Length == 0 then
			self.Text = self.Text:sub(1, self.Start) .. self.Text:sub(self.Start + 2)
		elseif self.Length > 0 then
			self.Text = self.Text:sub(1, self.Start) .. self.Text:sub(self.Start + self.Length + 1)
			self.Length = 0
		else
			self.Text = self.Text:sub(1, self.Start + self.Length) .. self.Text:sub(self.Start + 1)
			self.Start = math.max(self.Start + self.Length, 0)
			self.Length = 0
		end
		self:CalculateLines()
	elseif key == "left" then
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
			self.Length = math.max(self.Length - 1, -self.Start)
		else
			if self.Length == 0 then
				self.Start = math.max(self.Start - 1, 0)
				self.Length = 0
			elseif self.Length > 0 then
				self.Length = 0
			else
				self.Start = math.max(self.Start + self.Length, 0)
				self.Length = 0
			end
		end
	elseif key == "right" then
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
			self.Length = math.min(self.Length + 1, Length - self.Start)
		else
			if self.Length == 0 then
				self.Start = math.max(math.min(self.Start + self.Length + 1, Length), 0)
				self.Length = 0
			elseif self.Length > 0 then
				self.Start = math.max(math.min(self.Start + self.Length, Length), 0)
				self.Length = 0
			else
				self.Length = 0
			end
		end
	elseif key == "return" then
		self:Write("\n")
	end
end