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
	return self
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
		Format.Length = Format.Start + Format.Length - (Start + Length + 1)
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
end

-- This function is magic, it iterates through formats/non-formatted text/line breaks
function TTextarea:EachFormat()
	local DefaultFormat = {
		Font = self:GetFont(),
		Color = self:GetTheme().Text,
	}
	local Index, Format
	local Width = 0
	self.LongestWidth = 0
	return function ()
		if Format then
			local NextLine = next(Format.TextArray, Format.TextIndex)
			if NextLine then
				-- This part iterates to the next line break
				Format.TextArray[Format.TextIndex] = nil
				Format.TextIndex = NextLine
				Format.Text = Format.TextArray[NextLine]
				Format.Width = Format.Font:getWidth(Format.Text)
				Format.Height = Format.Font:getHeight()
				Format.LineBreak = true
				
				Width = Format.Width
				if Width > self.LongestWidth then
					self.LongestWidth = Width
				end
				
				-- Next line exists, push!
				return Format
			else
				Format.LineBreak = nil
			end
				
			if Format.Start + Format.Length == #self.Text or Format.Length == 0 then
				-- The last format returned all we had left, what are you expecting for?
				return nil
			end
			
			local NextIndex, NextFormat = next(self.Format, Index)
			if NextFormat == nil then
				-- Yea we sent the last format, but we didn't send everything
				DefaultFormat.Start = Format.Start + Format.Length
				DefaultFormat.Length = #self.Text - DefaultFormat.Start + 1
				Format = DefaultFormat
			elseif NextFormat.Start == Format.Start + Format.Length + 1 or Format == DefaultFormat then
				-- Oh, it looks like the next format starts just after this one ends, let's just send it
				Index = NextIndex
				Format = NextFormat
			else
				-- So, there's a string that is not formatted between the last format and the next one
				DefaultFormat.Start = Format.Start + Format.Length + 1
				DefaultFormat.Length = NextFormat.Start - DefaultFormat.Start
				Format = DefaultFormat
			end
		else
			local NextIndex, NextFormat = next(self.Format)
			if NextFormat then
				-- Yea it looks like the textarea is formatted
				if NextFormat.Start == 1 then
					-- That's nice, the format starts at the begining of the textarea
					Index = 1
					Format = NextFormat
				else
					-- We need to send the string between the begining of the textarea and the next format
					DefaultFormat.Start = 1
					DefaultFormat.Length = NextFormat.Start - 1
					Format = DefaultFormat
				end
			else
				-- We didn't set any format to this textarea? cool, less cpu usage!
				DefaultFormat.Start = 1
				DefaultFormat.Length = #self.Text
				Format = DefaultFormat
			end
		end
		if Format.Length == 0 then
			-- We don't return empty formats, it's a needless cpu waste
			return nil
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
		
		Width = Width + Format.Width
		if Width > self.LongestWidth then
			self.LongestWidth = Width
		end
		
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
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)
		
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)
		
		local WidthOffset, HeightOffset = 2.5, 2.5
		for Format in self:EachFormat() do
			love.graphics.setFont(Format.Font)
			love.graphics.setColor(unpack(Format.Color))
			
			if Format.LineBreak then
				HeightOffset = HeightOffset + Format.Height
				WidthOffset = 2.5
			end
			love.graphics.print(Format.Text, x + WidthOffset, y + HeightOffset)
			WidthOffset = WidthOffset + Format.Width
		end
	end
end