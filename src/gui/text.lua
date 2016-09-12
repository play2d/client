local Path, gui = ...
local utf8 = require("utf8")

local Text = {}
local TextMetatable = {__index = Text}

function gui.CreateText(String, Font, R, G, B, A)
	
	local self = {
		Text = String or "",
		Format = {},
		Line = {},
		Width = 0,
		Height = 0,
		Font = Font or love.graphics.getFont(),
		Color = {R or 255, G or 255, B or 255, A or 255},
	}
	
	setmetatable(self, TextMetatable)
	
	self:CalculateDimensions()

	return self
end

function Text:SetColor(R, G, B, A)
	
	self.Color[1] = R
	self.Color[2] = G
	self.Color[3] = B
	self.Color[4] = A
	
end

function Text:SetFont(Font)
	
	if Font ~= self.Font then
		
		self.Font = Font
		self:CalculateDimensions()
		
	end
	
end

function Text:Add(Text, Font, R, G, B, A)
	
	if Font and Color then
		
		local Start = self.Text:utf8len()
		local Length = Text:utf8len()
		local Format = {
			Font = Font,
			Color = {R, G, B, A},
		}
		
		for i = Start, Start + Length do
			
			self.Format[i] = Format
			
		end
		
	end
	
	self.Text = self.Text .. Text
	self:CalculateDimensions()
	
end

function Text:SetText(Text, Position, Length)
	
	local Position = Position or 1
	local Length = Length or #self.Text - Position
	
	local A = ""
	local B = ""
	
	if Position > 1 then
		
		A = self.Text:sub(1, utf8.offset(self.Text, Position))
		
	end
	
	if Length < #self.Text - Position then
		
		B = self.Text:sub(utf8.offset(self.Text, Position + Length - 1))
		
	end

	self.Text = A .. Text .. B
	self:CalculateDimensions()
	
end

function Text:Get()
	
	return self.Text
	
end

function Text:SetFormat(Position, Length, Font, R, G, B, A)
	
	local Format
	if Font or R or G or B or A then
		
		Format = {
			Font = Font;
		}
		
		if R or G or B or A then
			
			Format.Color = {
				R or self.Color[1];
				G or self.Color[2];
				B or self.Color[3];
				A or self.Color[4];
			}
			
		end
		
	end
	
	for i = Position, Position + Length - 1 do
		
		self.Format[i] = Format
		
	end
	
	self:CalculateDimensions()
	
end

function Text:SetPassword(Password)
	
	if Password ~= self.Password then
		
		if Password then
			
			self.Password = true
			
		else
			
			self.Password = nil
			
		end
		
		self:CalculateDimensions()
	end
	
end

function Text:GetPosition(x, y)
	
	y = math.max(y, 0)
	
	if self.Password then
		
		for _, Line in pairs(self.Line) do
			
			if y > Line.Altitude and y < Line.Altitude + Line.Height then
				
				if x < 0 then
					
					return Line.Start
					
				elseif x > Line.Width then
					
					return Line.Start + Line.Text:utf8len()
					
				end
				
				local WidthOffset = 0
				
				for i = 1, Line.Text:utf8len() do
					
					local Format = self.Format[i + Line.Start] or self
					local Char = Line.Text:utf8sub(i, i)
					
					if Char ~= "\n" then
						
						Char = "*"
						
					end
					
					local Font = Format.Font or self.Font
					local CharWidth = Font:getWidth(Char)
					local CharHeight = Font:getHeight(Char)
					
					if x >= WidthOffset and x <= WidthOffset + CharWidth then
						
						return Line.Start + i - 1
						
					end
					
					WidthOffset = WidthOffset + CharWidth
					
				end
				
				break
				
			end
			
		end
		
	else
		
		for _, Line in pairs(self.Line) do
			
			if y > Line.Altitude and y < Line.Altitude + Line.Height then
				
				if x < 0 then
					
					return Line.Start
					
				elseif x > Line.Width then
					
					return Line.Start + Line.Text:utf8len()
					
				end
				
				local WidthOffset = 0
				
				for i = 1, utf8.len(Line.Text) do
					
					local Format = self.Format[i + Line.Start] or self
					local Char = Line.Text:utf8sub(i, i)

					local Font = Format.Font or self.Font
					local CharWidth = Font:getWidth(Char)
					local CharHeight = Font:getHeight(Char)
					
					if x >= WidthOffset and x <= WidthOffset + CharWidth then
						
						return Line.Start + i - 1
						
					end
					
					WidthOffset = WidthOffset + CharWidth
					
				end
				
				break
				
			end
			
		end
		
	end
	
	return self.Text:utf8len() + 1
	
end

function Text:CalculateDimensions()
	
	self.Line = {
		{
			Text = "",
			Start = 1,
			Width = 0,
			Height = 0,
			Altitude = 0,
		}
	}
	
	self.Width = 0
	self.Height = 0
	
	local Line = self.Line[1]
	local LineNumber = 1
	if self.Password then
		
		for i = 1, self.Text:utf8len() do
			
			local Format = self.Format[i] or self
			local Char = self.Text:utf8sub(i, i)
			
			if Char ~= "\n" then
				Char = "*"
			end
			
			local Font = Format.Font or self.Font
			local CharWidth = Font:getWidth(Char)
			local CharHeight = Font:getHeight(Char)
			
			if CharHeight > Line.Height then
				
				Line.Height = CharHeight
				
			end
			
			if Char == "\n" then
				
				if Line.Width > self.Width then
					
					self.Width = Line.Width
					
				end
				
				self.Height = self.Height + Line.Height
				
				Line = {
					Text = "",
					Width = 0,
					Height = self.Font:getHeight(),
					Start = Line.Start + Line.Text:utf8len() + 1,
					Altitude = Line.Altitude + Line.Height,
				}
				
				LineNumber = LineNumber + 1
				
				self.Line[LineNumber] = Line
				
			else
				
				Line.Text = Line.Text .. Char
				Line.Width = Line.Width + CharWidth
				
			end
			
		end
		
	else
		
		for i = 1, self.Text:utf8len() do
			
			local Format = self.Format[i] or self
			local Char = self.Text:utf8sub(i, i)
			
			local Font = Format.Font or self.Font
			local CharWidth = Font:getWidth(Char)
			local CharHeight = Font:getHeight(Char)
			
			if CharHeight > Line.Height then
				
				Line.Height = CharHeight
				
			end
			
			if Char == "\n" then
				
				if Line.Width > self.Width then
					
					self.Width = Line.Width
					
				end
				
				self.Height = self.Height + Line.Height
				
				Line = {
					Text = "",
					Width = 0,
					Height = self.Font:getHeight(),
					Start = Line.Start + Line.Text:utf8len() + 1,
					Altitude = Line.Altitude + Line.Height,
				}
				
				LineNumber = LineNumber + 1
				self.Line[LineNumber] = Line
				
			else
				
				Line.Text = Line.Text .. Char
				Line.Width = Line.Width + CharWidth
				
			end
			
		end
		
	end
	
	if Line.Width > self.Width then
		
		self.Width = Line.Width
		
	end
	
	self.Height = self.Height + Line.Height
	
end

function Text:getWidth()
	
	return self.Width
	
end

function Text:getHeight()
	
	return self.Height
	
end

function Text:Draw(x, y)
	
	if self.Password then
		
		for _, Line in pairs(self.Line) do
			
			local WidthOffset = 0
			
			for i = 1, Line.Text:utf8len() do
				
				local Format = self.Format[i + Line.Start] or self
				local Char = Line.Text:utf8sub(i, i)
				
				if Char == "\n" then
					
					break
					
				else
					
					Char = "*"
					
				end

				local Font = Format.Font or self.Font
				local CharWidth = Font:getWidth(Char)
				local CharHeight = Font:getHeight(Char)
				
				love.graphics.setColor(Format and Format.Color or self.Color)
				love.graphics.setFont(Font)
				love.graphics.print(Char, math.floor(x + WidthOffset), math.floor(y + Line.Altitude + Line.Height - CharHeight))
				
				WidthOffset = WidthOffset + CharWidth
				
			end
			
		end
		
	else
		
		for _, Line in pairs(self.Line) do
			
			local WidthOffset = 0
			
			for i = 1, Line.Text:utf8len() do
				
				local Format = self.Format[i + Line.Start] or self
				local Char = Line.Text:utf8sub(i, i)

				local Font = Format.Font or self.Font
				local CharWidth = Font:getWidth(Char)
				local CharHeight = Font:getHeight(Char)
				
				love.graphics.setColor(Format and Format.Color or self.Color)
				love.graphics.setFont(Font)
				love.graphics.print(Char, math.floor(x + WidthOffset), math.floor(y + Line.Altitude + Line.Height - CharHeight))
				
				WidthOffset = WidthOffset + CharWidth
				
			end
			
		end
		
	end
	
end

function Text:DrawOffset(x, y, Altitude, Height)
	
	if self.Password then
		
		for _, Line in pairs(self.Line) do
			
			if Altitude > -Line.Height then
				
				if Line.Altitude + Altitude > Height then
					
					break
					
				end
				
				local WidthOffset = 0
				
				for i = 1, Line.Text:utf8len() do
					
					local Format = self.Format[i + Line.Start] or self
					local Char = Line.Text:utf8sub(i, i)
					
					if Char == "\n" then
						
						break
						
					else
						
						Char = "*"
						
					end

					local Font = Format.Font or self.Font
					local CharWidth = Font:getWidth(Char)
					local CharHeight = Font:getHeight(Char)
					
					love.graphics.setColor(Format and Format.Color or self.Color)
					love.graphics.setFont(Font)
					love.graphics.print(Char, math.floor(x + WidthOffset), math.floor(y + Line.Altitude + Line.Height - CharHeight))
					
					WidthOffset = WidthOffset + CharWidth
					
				end
				
			end
			
			Altitude = Altitude + Line.Height
			
		end
		
	else
		
		for _, Line in pairs(self.Line) do
			
			if Altitude > -Line.Height then
				
				if Altitude > Height then
					
					break
					
				end
				
				local WidthOffset = 0
				
				for i = 1, Line.Text:utf8len() do
					
					local Format = self.Format[i + Line.Start] or self
					local Char = Line.Text:utf8sub(i, i)
					
					local Font = Format.Font or self.Font
					local CharWidth = Font:getWidth(Char)
					local CharHeight = Font:getHeight(Char)
					
					love.graphics.setColor(Format and Format.Color or self.Color)
					love.graphics.setFont(Font)
					love.graphics.print(Char, math.floor(x + WidthOffset), math.floor(y + Line.Altitude + Line.Height - CharHeight))
					
					WidthOffset = WidthOffset + CharWidth
					
				end
				
			end
			
			Altitude = Altitude + Line.Height
			
		end
		
	end
	
end