local TCheckbox = {}
local TCheckboxMetatable = {__index = TCheckbox}
TCheckbox.Type = "Checkbox"
setmetatable(TCheckbox, gui.TGadgetMetatable)

function gui.CreateCheckbox(Text, x, y, Width, Height, Parent)
	local Checkbox = TCheckbox.New()
	if Parent:AddGadget(Checkbox) then
		Checkbox:SetText(Text)
		Checkbox:SetDimensions(Width, Height)
		Checkbox:SetPosition(x, y)
		return Checkbox:Init()
	end
end

function TCheckbox:New()
	return setmetatable({}, TCheckboxMetatable)
end

function TCheckbox:Render(dt)
	if not self.Hidden then
		local x, y = self:GetPosition()
		local Width, Height = self:GetDimensions()
		local Theme = self:GetTheme()
		love.graphics.setScissor(x - 1, y - 1, Width + self.TextWidth + 7, Height + 2)

		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)

		if self:IsHovered() then
			love.graphics.setColor(unpack(Theme.HoverBackground))
		else
			love.graphics.setColor(unpack(Theme.Background))
		end
		love.graphics.rectangle("fill", x, y, Width, Height)

		local Font = self:GetFont()
		love.graphics.setColor(unpack(Theme.Text))
		love.graphics.setFont(Font)
		love.graphics.print(self.Text, x + Width + 5, y + (Height - Font:getHeight())/2)

		if self.Status then
			love.graphics.setColor(255, 255, 255, 255)
			local Mark = Theme.MarkImage
			love.graphics.draw(Mark, x + (Width - Mark:getWidth())/2, y + (Height - Mark:getHeight())/2)
		end
		self:RenderGadgets(dt)
	end
end

function TCheckbox:MouseClicked(x, y)
	if self.BaseClass.MouseClicked(self, x, y) then
		self.Status = not self.Status
		return true
	end
end

function TCheckbox:SetText(Text)
	self.Text = Text
	self.TextWidth = self:GetFont():getWidth(Text)
end
