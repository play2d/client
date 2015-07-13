local TSlider = {}
local TSliderMetatable = {__index = TSlider}
TSlider.Value = 0
TSlider.Type = "Slider"
setmetatable(TSlider, gui.TGadgetMetatable)

gui.SLIDER_VER = 1
gui.SLIDER_HOR = 2

function gui.CreateSlider(Type, x, y, Width, Height, Parent, ValCount, ValMax)
	local Slider = TSlider.New()
	if Parent:AddGadget(Slider) then
		Slider.Heading = Type
		Slider:SetValues(ValCount, ValMax)
		Slider:SetPosition(x, y)
		Slider:SetSize(Width, Height)
		return Slider
	end
end

function TSlider.New()
	return setmetatable({}, TSliderMetatable)
end

function TSlider:SetValues(Count, Max)
	local Max = Max > 0 and Max or 1
	local Count = math.min(Count, Max)
	self.Values = {
		Count = Count,
		Max = Max
	}
end

function TSlider:BarSize()
	if self.Heading == gui.SLIDER_VER then
		return math.floor(self.Values.Count/self.Values.Max * self:Height() - 3.5)
	else
		return math.floor(self.Values.Count/self.Values.Max * self:Width() - 3.5)
	end
end

function TSlider:BarPosition()
	if self.Heading == gui.SLIDER_VER then
		return math.floor(self.Value/self.Values.Max * (self:Height() - self:BarSize() - 4) + 2.5)
	else
		return math.floor(self.Value/self.Values.Max * (self:Width() - self:BarSize() - 4) + 2.5)
	end
end

function TSlider:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:Width(), self:Height()
		local BarPosition = self:BarPosition()
		local BarSize = self:BarSize()
		local Color = self:GetTheme()
		love.graphics.setScissor(x - 1, y - 1, Width + 2, Height + 2)

		if self.Heading == gui.SLIDER_VER then
			love.graphics.setColor(unpack(Color.Border))
			love.graphics.rectangle("line", x, y, Width, Height)

			love.graphics.setColor(unpack(Color.Background))
			love.graphics.rectangle("fill", x, y, Width, Height)

			love.graphics.setColor(unpack(Color.Border))
			love.graphics.rectangle("line", x, y + BarPosition, Width, BarSize)

			if self.Grabbed then
				love.graphics.setColor(unpack(Color.Bar.HoldBackground))
			elseif self:GetHoverAll() == self then
				love.graphics.setColor(unpack(Color.Bar.HoverBackground))
			else
				love.graphics.setColor(unpack(Color.Bar.Background))
			end
			love.graphics.rectangle("fill", x, y + BarPosition, Width, BarSize)

			love.graphics.setColor(unpack(Color.Lines))
			love.graphics.line(x + 3, y + BarPosition + BarSize/2 - 3, x + Width - 3, y + BarPosition + BarSize/2 - 3)
			love.graphics.line(x + 3, y + BarPosition + BarSize/2, x + Width - 3, y + BarPosition + BarSize/2)
			love.graphics.line(x + 3, y + BarPosition + BarSize/2 + 3, x + Width - 3, y + BarPosition + BarSize/2 + 3)
		elseif self.Heading == gui.SLIDER_HOR then
			love.graphics.setColor(unpack(Color.Border))
			love.graphics.rectangle("line", x, y, Width, Height)

			love.graphics.setColor(unpack(Color.Background))
			love.graphics.rectangle("fill", x, y, Width, Height)

			love.graphics.setColor(unpack(Color.Bar.Border))
			love.graphics.rectangle("line", x + BarPosition, y, BarSize, Height)

			if self.Grabbed then
				love.graphics.setColor(unpack(Color.Bar.HoldBackground))
			elseif self:GetHoverAll() == self then
				love.graphics.setColor(unpack(Color.Bar.HoverBackground))
			else
				love.graphics.setColor(unpack(Color.Bar.Background))
			end
			love.graphics.rectangle("fill", x + BarPosition, y, BarSize, Height)

			love.graphics.setColor(unpack(Color.Lines))
			love.graphics.line(x + BarPosition + BarSize/2 - 3, y + 3, x + BarPosition + BarSize/2 - 3, y + Height - 3)
			love.graphics.line(x + BarPosition + BarSize/2, y + 3, x + BarPosition + BarSize/2, y + Height - 3)
			love.graphics.line(x + BarPosition + BarSize/2 + 3, y + 3, x + BarPosition + BarSize/2 + 3, y + Height - 3)
		end
	end
end

function TSlider:MouseMove(x, y, dx, dy)
	if not self.Disabled then
		if self.Heading == gui.SLIDER_VER then
			self.Value = math.max(math.min(self.Value + dy/(self:Height() - self:BarSize()) * self.Values.Max, self.Values.Max), 0)
		elseif self.Heading == gui.SLIDER_HOR then
			self.Value = math.max(math.min(self.Value + dx/(self:Width() - self:BarSize()) * self.Values.Max, self.Values.Max), 0)
		end
	end
end
