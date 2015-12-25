local love_graphics_newImage = love.graphics.newImage

function love.graphics.newImage(...)
	local Success, Image = pcall(love_graphics_newImage, ...)
	if Success then
		return Image
	end
	
	local FileName = ...
	local File = io.open(FileName, "rb")
	if File then
		
		local FileData = love.filesystem.newFileData(File:read("*a"), FileName)
		File:close()

		if FileData then
			local ImageData = love.image.newImageData(FileData)
			
			if ImageData then
				
				return love_graphics_newImage(ImageData)
			end
		end
		
	end
end