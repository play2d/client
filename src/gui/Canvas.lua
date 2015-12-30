local TCanvas = {}
local TCanvasMetatable = {__index = TCanvas}
TCanvas.Type = "Canvas"
setmetatable(TCanvas, gui.TGadgetMetatable)

function gui.CreateCanvas(x, y, Width, Height, Parent, Background)
	local Canvas = TCanvas.New()
	if Parent:AddGadget(Canvas) then
		Canvas:SetPosition(x, y)
		Canvas:SetDimensions(Width, Height)
		Canvas:SetBackground(Background)
		return Canvas:Init()
	end
end

function TCanvas.New()
	return setmetatable({}, TCanvasMetatable)
end

function TCanvas:Init()
	self.Gadgets = {}
	self.GadgetsOrder = {}
	return self
end

function TCanvas:SetBackground(Background)
	self.Background = Background
end

function TCanvas:HoverGadget()
	if not self.Hidden then
		if self.GadgetsOrder then
			local HoverGadget
			for _, Gadget in pairs(self.GadgetsOrder) do
				local HoverChild = Gadget:HoverGadget()
				if HoverChild then
					HoverGadget = HoverChild
				end
			end
			if HoverGadget then
				return HoverGadget
			end
		end
		-- Canvas shall never return itself, otherwise it will cover necessary things
	end
end

function TCanvas:Draw(x, y, Width, Height, dt)
end

function TCanvas:Render(dt)
	if not self.Hidden then
		local x, y = self:GetPosition()
		local Width, Height = self:GetDimensions()
		local Theme = self:GetTheme()
		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Color))
		if self.Background then
			love.graphics.draw(self.Background, x, y)
		end
		
		self:Draw(x, y, Width, Height, dt)
		self:RenderGadgets(dt)
	end
end