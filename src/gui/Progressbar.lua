local TProgressbar = {}
local TProgressbarMetatable = {__index = TProgressbar}
TProgressbar.Type = "Progressbar"
TProgressbar.Progress = 0
setmetatable(TProgressbar, gui.TGadgetMetatable)

function gui.CreateProgressbar(x, y, Width, Height, Parent)
	local Progressbar = TProgressbar.New()
	if Parent:AddGadget(Progressbar) then
		Progressbar:SetPosition(x, y, Width, Height)
		Progressbar:SetDimensions(Width, Height)
		return Progressbar
	end
end

function TProgressbar.New()
	return setmetatable({}, TProgressbarMetatable)
end

function TProgressbar:Render(dt)
	if not self.Hidden then
		local x, y = self:GetPosition()
		local Width, Height = self:GetDimensions()
		local Theme = self:GetTheme()
		local Font = self:GetFont()
		
		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)
		
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)
		
		local ProgressWidth = Width * self.Progress / 100 - 2
		love.graphics.setColor(unpack(Theme.Top))
		love.graphics.rectangle("fill", x + 1, y + 1, ProgressWidth, Height/2 - 1)
		
		love.graphics.setColor(unpack(Theme.Bottom))
		love.graphics.rectangle("fill", x + 1, y + Height / 2, ProgressWidth, Height/2 - 1)
		
		love.graphics.setColor(unpack(Theme.Text))
		love.graphics.setFont(Font)
		
		local Text
		if self.Text then
			Text = self.Text.." - "..self.Progress.." %"
		else
			Text = self.Progress.." %"
		end
		love.graphics.print(Text, x + (Width - Font:getWidth(Text))/2, y + (Height - Font:getHeight())/2)
		self:RenderGadgets(dt)
	end
end