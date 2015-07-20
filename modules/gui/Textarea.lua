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
	self.LinePosition = {}
	self.Line = {}
	return self
end

function TTextarea:SetText(Text)
	self.Text = Text
	self.LinePosition = {}
	self.Line = {}
	for Position, Line in Text:gmatch("()(^[\n]+)") do
		table.insert(self.LinePosition, Position)
		table.insert(self.Line, Line)
	end
	
	local MaximumWidth, MaximumHeight = 0, 0
	for i, Format in pairs(self.Format) do
	end
end

function TTextarea:SetFormat(Start, Length, Font, R, G, B, A)
	local FormatI, Format
	while true do
		local NextI, NextFormat = next(self.Format, FormatI)
		if NextFormat.Start > Start then
			-- Find the closest format before this one we're creating
			break
		end
		FormatI = NextI
		Format = NextFormat
	end
	if Format and Format.Start + Format.Length > Start then
		-- Reduce the length of the previous format
		Format.Length = Start - Format.Start
	end
	FormatI, Format = next(self.Format, FormatI)
	if Format and Format.Start < Start + Length then
		-- Reduce the length of the next format
		Format.Length = (Start + Length + 1) - Format.Start
		-- Increase the position of the next format
		Format.Start = Start + Length + 1
		self.Format[FormatI] = nil
		self.Format[Format.Start] = Format
	end
	table.insert(self.Format,
		{
			Start = Start,
			Length = Length,
			Font = Font,
			Color = {R, G, B, A}
		}
	)
	table.sort(self.Format, function (A, B) return A.Start < B.Start end)
end

function TTextarea:EachFormat()
	local DefaultFormat = {}
	local Index, Format
	return function ()
		if Format then
			if Format.Start + Format.Length == #self.Text or Format.Length == 0 then
				return nil
			end
			local NextIndex, NextFormat = next(self.Format, Index)
			if NextFormat == nil then
				DefaultFormat.Start = Format.Start + Format.Length
				DefaultFormat.Length = #self.Text - DefaultFormat.Start + 1
				Format = DefaultFormat
			elseif NextFormat.Start == Format.Start + Format.Length + 1 or Format == DefaultFormat then
				Index = NextIndex
				Format = NextFormat
			else
				DefaultFormat.Start = Format.Start + Format.Length + 1
				DefaultFormat.Length = NextFormat.Start - DefaultFormat.Start
				Format = DefaultFormat
			end
		else
			local NextIndex, NextFormat = next(self.Format)
			if NextFormat then
				if NextFormat.Start == 1 then
					Index = 1
					Format = NextFormat
				else
					DefaultFormat.Start = 1
					DefaultFormat.Length = NextFormat.Start - 1
					Format = DefaultFormat
				end
			else
				DefaultFormat.Start = 1
				DefaultFormat.Length = #self.Text
				Format = DefaultFormat
			end
		end
		if Format.Length == 0 then
			return nil
		end
		Format.Text = self.Text:sub(Format.Start, Format.Start + Format.Length - 1)
		return Format
	end
end

function TTextarea:Render(dt)
end