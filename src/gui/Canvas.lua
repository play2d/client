local TCanvas = {}
local TCanvasMetatable = {__index = TCanvas}
TCanvas.Type = "Canvas"
setmetatable(TCanvas, gui.TGadgetMetatable)

function gui.CreateCanvas(x, y, Width, Height, Parent)
	local Canvas = TCanvas.New()
	if Parent:AddGadget(Canvas) then
		Canvas:SetPosition(x, y)
		Canvas:SetDimensions(Width, Height)
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

function TCanvas:Draw(x, y, Width, Height, dt)
end

function TCanvas:Render(dt)
	if not self.Hidden then
		local x, y = self:GetPosition()
		local Width, Height = self:GetDimensions()
		love.graphics.setScissor(x, y, Width, Height)
		self:Draw(x, y, Width, Height, dt)
		self:RenderGadgets(dt)
	end
end