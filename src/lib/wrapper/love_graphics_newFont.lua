local love_graphics_newFont = love.graphics.newFont

function love.graphics.newFont(...)
	local Success, Font = pcall(love_graphics_newFont, ...)
	if Success then
		return Font
	end
	
	local FileName, Size = ...
	local File = io.open(FileName, "rb")
	if File then
		
		local FileData = love.filesystem.newFileData(File:read("*a"), FileName)
		File:close()
		
		if FileData then
			return love_graphics_newFont(FileData, Size)
		end
		
	end
end