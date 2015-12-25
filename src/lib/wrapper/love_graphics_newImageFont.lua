local love_graphics_newImageFont = love.graphics.newImageFont

function love.graphics.newImageFont(...)
	local Success, ImageFont = pcall(love_graphics_newImageFont)
	if Success then
		return ImageFont
	end
	
	local ImagePath, Glyphs = ...
	local Image = love.graphics.newImage(ImagePath)
	
	if Image then
		
		return love_graphics_newImageFont(Image)
	end
end