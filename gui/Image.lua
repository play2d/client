local TImage = {}
local TImageMetatable = {__index = TImage}
TImage.Type = "Image"
setmetatable(TImage, gui.TGadgetMetatable)

function gui.CreateImage(ImageData, x, y, Width, Height, Parent)
	local Image = TImage.New()
	if Parent:AddGadget(Image) then
		Image:SetPosition(x, y)
		Image:SetSize(Width, Height)
		Image.Image = ImageData
		return Image
	end
end

function TImage.New()
	return setmetatable({}, TImageMetatable)
end

function TImage:Width()
	if self.Size.Width then
		return self.Size.Width
	end
	return self.Image:getWidth()
end

function TImage:Height()
	if self.Size.Height then
		return self.Size.Height
	end
	return self.Image:getHeight()
end

function TImage:Render()
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:Width(), self:Height()
		local Theme = self:GetTheme()
		love.graphics.setScissor(x - 1, y - 1, Width + 2, Height + 2)
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.draw(self.Image, x, y, 0, Width/self.Image:getWidth(), Height/self.Image:getHeight())
	end
end
