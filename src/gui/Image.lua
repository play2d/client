local TImage = {}
local TImageMetatable = {__index = TImage}
TImage.Type = "Image"
setmetatable(TImage, gui.TGadgetMetatable)

function gui.CreateImage(ImageData, x, y, Width, Height, Parent)
	local Image = TImage.New()
	if Parent:AddGadget(Image) then
		Image:SetPosition(x, y)
		Image:SetDimensions(Width, Height)
		Image.Image = ImageData
		return Image
	end
end

function TImage.New()
	return setmetatable({}, TImageMetatable)
end

function TImage:GetWidth()
	if self.Size.Width then
		return self.Size.Width
	elseif self.Image then
		return self.Image:getWidth()
	end
	return self.BaseClass.GetWidth(self)
end

function TImage:GetHeight()
	if self.Size.Height then
		return self.Size.Height
	elseif self.Image then
		return self.Image:getHeight()
	end
	return self.BaseClass.GetHeight(self)
end

function TImage:Render(dt)
	if not self.Hidden then
		local x, y = self:GetPosition()
		local Width, Height = self:GetDimensions()
		local Theme = self:GetTheme()
		love.graphics.setScissor(x - 1, y - 1, Width + 2, Height + 2)
		love.graphics.setColor(unpack(Theme.Background))
		if self.Image then
			love.graphics.draw(self.Image, x, y, 0, Width/self.Image:getWidth(), Height/self.Image:getHeight())
		end
		self:RenderGadgets(dt)
	end
end
