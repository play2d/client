local TButton = {}
local TButtonMetatable = {__index = TButton}
TButton.Type = "Button"
setmetatable(TButton, gui.TGadgetMetatable)

function gui.CreateButton(Text, x, y, Width, Height, Parent)
	local Button = TButton.New()
	if Parent:AddGadget(Button) then
		Button:SetPosition(x, y)
		Button:SetSize(Width, Height)
		Button:SetText(Text)
		return Button:Init()
	end
end

function TButton.New()
	return setmetatable({}, TButtonMetatable)
end

function TButton:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:Width(), self:Height()
		local Theme = self:GetTheme()
		love.graphics.setScissor(x - 1, y - 1, Width + 2, Height + 2)

		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)

		if self.Grabbed then
			love.graphics.setColor(unpack(Theme.HoldTop))
			love.graphics.rectangle("fill", x, y, Width, Height/2)

			love.graphics.setColor(unpack(Theme.HoldBottom))
			love.graphics.rectangle("fill", x, y + Height/2, Width, Height/2)

			love.graphics.setColor(unpack(Theme.HoldText))
		elseif self:IsHovered() then
			love.graphics.setColor(unpack(Theme.HoverTop))
			love.graphics.rectangle("fill", x, y, Width, Height/2)

			love.graphics.setColor(unpack(Theme.HoverBottom))
			love.graphics.rectangle("fill", x, y + Height/2, Width, Height/2)

			love.graphics.setColor(unpack(Theme.HoverText))
		else
			love.graphics.setColor(unpack(Theme.Top))
			love.graphics.rectangle("fill", x, y, Width, Height/2)

			love.graphics.setColor(unpack(Theme.Bottom))
			love.graphics.rectangle("fill", x, y + Height/2, Width, Height/2)

			love.graphics.setColor(unpack(Theme.Text))
		end

		local Font = self:GetFont()
		love.graphics.setFont(Font)
		love.graphics.print(self.Text, x + (Width - Font:getWidth(self.Text))/2, y + (Height - Font:getHeight())/2)
		self:RenderGadgets(dt)
	end
end
