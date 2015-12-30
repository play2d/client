function love.graphics.filterMagenta(Image)
	if Image:typeOf("Image") then
		local ImageData = Image:getData()
		for x = 0, ImageData:getWidth() - 1 do
			for y = 0, ImageData:getHeight() - 1 do
				local R, G, B, A = ImageData:getPixel(x, y)
				if R == 255 and G == 0 and B == 255 then
					ImageData:setPixel(x, y, 0, 0, 0, 0)
				end
			end
		end
		return love.graphics.newImage(ImageData)
	end
	return Image
end