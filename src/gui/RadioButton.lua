local TRadioButton = {}
local TRadioButtonMetatable = {__index = TRadioButton}
TRadioButton.Type = "RadioButton"
setmetatable(TRadioButton, gui.TGadgetMetatable)

function gui.CreateRadioButton(Text, x, y, Radius, Parent)
	local RadioButton = TRadioButton.New()
	if Parent:AddGadget(RadioButton) then
		RadioButton:SetText(Text)
		RadioButton:SetPosition(x, y)
		RadioButton:SetRadius(Radius)
		return RadioButton:Init()
	end
end

function TRadioButton.New()
	return setmetatable({}, TRadioButtonMetatable)
end

function TRadioButton:Init()
	if not self.Parent.RadioButton then
		self.Parent.RadioButton = self
	end
	return self
end

function TRadioButton:MouseClicked(x, y)
	if self.BaseClass.MouseClicked(self, x, y) then
		self.Parent.RadioButton = self
		return true
	end
end

function TRadioButton:SetRadius(Radius)
	self.Size = {Radius = Radius}
end

function TRadioButton:GetRadius()
	return self.Size.Radius
end

function TRadioButton:MouseHover()
	if not self.Hidden then
		local MouseX, MouseY = love.mouse.getPosition()
		local x, y = self:GetPosition()
		local Radius = self:GetRadius()
		return ((x - MouseX + Radius)^2 + (y - MouseY + Radius)^2)^0.5 < Radius
	end
end

function TRadioButton:Render(dt)
	if not self.Hidden then
		local x, y = self:GetPosition()
		local Radius = self:GetRadius()
		local Theme = self:GetTheme()
		
		love.graphics.setScissor(x - 1, y - 1, Radius * 2 + 2, Radius * 2 + 2)
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.circle("line", x + Radius, y + Radius, Radius, 2 * math.pi * Radius)
		
		if self.Parent.RadioButton == self then
			love.graphics.setColor(unpack(Theme.Background))
			love.graphics.circle("fill", x + Radius, y + Radius, Radius - 2, 2 * math.pi * Radius)
		elseif self:IsHovered() then
			love.graphics.setColor(unpack(Theme.HoverBackground))
			love.graphics.circle("fill", x + Radius, y + Radius, Radius - 2, 2 * math.pi * Radius)
		end
		
		local Font = self:GetFont()
		local FontHeight = Font:getHeight()
		love.graphics.setScissor(x + Radius * 2 + 5, y + (Radius * 2 - FontHeight)/2, Font:getWidth(self.Text), FontHeight)
		love.graphics.setColor(unpack(Theme.Text))
		love.graphics.print(self.Text,
			math.floor(x + Radius * 2 + 5),
			math.floor(y + (Radius * 2 - FontHeight)/2)
		)
	end
end