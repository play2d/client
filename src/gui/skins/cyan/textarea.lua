local Path, gui = ...
local TextArea = {}

TextArea.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
TextArea.TextColor = {80, 80, 80, 255}
TextArea.BackgroundColor = {255, 255, 255, 255}
TextArea.BorderColor = {80, 80, 80, 255}

local function SliderValue(Slider)
	Slider.Parent.Changed = true
end

function TextArea:Init()
	local Width, Height = self:GetDimensions()
	
	self.Layout.TextFont = TextArea.TextFont
	self.Layout.TextColor = TextArea.TextColor
	self.Layout.BackgroundColor = TextArea.Background
	self.Layout.BorderColor = TextArea.BorderColor
	
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))

	self.Layout.VSlider = gui.create("VSlider", 0, 0, 15, Height - 14, self)
	self.Layout.VSlider.OnValue = SliderValue
	
	self.Layout.HSlider = gui.create("HSlider", 0, 0, Width - 14, 15, self)
	self.Layout.HSlider.OnValue = SliderValue
end

function TextArea:GetMousePosition(x, y)
	return self.Text:GetPosition(
		x + self.Layout.HSlider.Value * (self.Layout.HSlider.Max - self:GetWidth()) / self.Layout.HSlider.Max,
		y + self.Layout.VSlider.Value * (self.Layout.VSlider.Max - self:GetHeight()) / self.Layout.VSlider.Max
	)
end

function TextArea:UpdateLayout()
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

function TextArea:UpdateText(Write)
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
				
				self.Layout.VSlider:SetValue(Line.Altitude + Line.Height)
				self.Layout.HSlider:SetValue(WidthOffset)
				self.Changed = true
				break
			end
		end
	end
end

function TextArea:WheelMoved(x, y)
	self.Layout.VSlider:SetValue(self.Layout.VSlider.Value - y * 15)
	self.Changed = true
end

function TextArea:MakePopup()
	self.Changed = true
end

function TextArea:MakePulldown()
	self.Changed = true
end

function TextArea:Render()
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

return TextArea