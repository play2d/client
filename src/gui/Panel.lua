local TPanel = {}
local TPanelMetatable = {__index = TPanel}
TPanel.Type = "Panel"
TPanel.Text = ""
setmetatable(TPanel, gui.TGadgetMetatable)

function gui.CreatePanel(Text, x, y, Width, Height, Parent)
	local Panel = TPanel.New()
	if Parent:AddGadget(Panel) then
		Panel:SetPosition(x, y)
		Panel:SetDimensions(Width, Height)
		Panel:SetText(Text)
		return Panel:Init()
	end
end

function TPanel.New()
	return setmetatable({}, TPanelMetatable)
end

function TPanel:Init()
	self.Gadgets = {}
	self.GadgetsOrder = {}
	return self
end

function TPanel:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:GetDimensions()
		local Theme = self:GetTheme()
		local Font = self:GetFont()
		
		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x, y + 5, Width, Height - 5)
		
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.line {x + 1, y + 6, x + 1, y + Height}
		love.graphics.line {x + 1, y + 5, x + 5, y + 5}
		love.graphics.line {x + 2, y + Height - 1, x + Width, y + Height - 1}
		love.graphics.line {x + Width - 1, y + 6, x + Width - 1, y + Height - 2}
		love.graphics.line {x + Font:getWidth(self.Text) + 10, y + 5, x + Width, y + 5}
		
		love.graphics.setFont(Font)
		love.graphics.setColor(unpack(Theme.Text))
		love.graphics.print(self.Text, x + 7.5, y)
		
		self:RenderGadgets()
	end
end