local Path, gui = ...
local TextField = {}

TextField.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
TextField.TextColor = {80, 80, 80, 255}
TextField.HintColor = {140, 140, 140, 255}
TextField.BackgroundColor = {255, 255, 255, 255}
TextField.BorderColor = {80, 80, 80, 255}

function TextField:Init()
	self.Layout.TextFont = TextField.TextFont
	self.Layout.TextColor = TextField.TextColor
	self.Layout.HintColor = TextField.HintColor
	self.Layout.BackgroundColor = TextField.BackgroundColor
	self.Layout.BorderColor = TextField.BorderColor
	
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.HintText:SetFont(self.Layout.TextFont)
	self.HintText:SetColor(unpack(self.Layout.HintColor))
	
	self.Layout.Offset = 0
end

function TextField:UpdateLayout()
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
	self.HintText:SetFont(self.Layout.TextFont)
	self.HintText:SetColor(unpack(self.Layout.HintColor))
end

function TextField:GetMousePosition(x, y)
	return self.Text:GetPosition(x + self.Layout.Offset, y)
end

function TextField:MoveLeft(Offset)
	self.Layout.Offset = math.max(self.Layout.Offset - Offset, 1)
	self.Changed = true
end

function TextField:MoveRight(Offset)
	self.Layout.Offset = math.max(math.min(self.Layout.Offset + Offset, self.Text:getWidth() - self:GetWidth()), 0)
	self.Changed = true
end

function TextField:MakePulldown()
	self.Changed = true
end

function TextField:UpdateText()
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

function TextField:Render()
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
			local Offset = -self.Layout.Offset + 2.5
			
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

return TextField