local _newImage = love.graphics.newImage
local _newImageData = love.graphics.newImageData
local _newCompressedData = love.image.newCompressedData
local _newFont = love.graphics.newFont
local _newImageFont = love.graphics.newImageFont
local _setNewFont = love.graphics.setNewFont
local _newDecoder = love.sound.newDecoder
local _newSoundData = love.sound.newSoundData
local _newSource = love.audio.newSource

function love.graphics.newImage(filename, ...)
	local OK, Image = pcall(_newImage, filename, ...)
	if OK then
		return Image
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, ImageData = pcall(_newImageData, FileData)
		if not OK then
			return nil
		end

		local OK, Image = pcall(_newImage, ImageData)
		if OK then
			return Image
		end
	end
end

function love.graphics.newImageData(filename, ...)
	local OK, ImageData = pcall(_newImageData, filename, ...)
	if OK then
		return ImageData
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, ImageData = pcall(_newImageData, FileData)
		if OK then
			return ImageData
		end
	end
end

function love.image.newCompressedData(filename)
	local OK, CompressedData = pcall(_newCompressedData, filename)
	if OK then
		return CompressedData
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, CompressedData = pcall(_newCompressedData, FileData)
		if OK then
			return CompressedData
		end
	end
end

function love.graphics.newFont(filename, ...)
	local OK, Font = pcall(_newFont, filename, ...)
	if OK then
		return Font
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, Font = pcall(_newFont, FileData, ...)
		if OK then
			return Font
		end
	end
end

function love.graphics.newImageFont(filename, ...)
	local OK, ImageFont = pcall(_newImageFont, filename, ...)
	if OK then
		return ImageFont
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, ImageFont = pcall(_newImageFont, FileData, ...)
		if OK then
			return ImageFont
		end
	end
end

function love.graphics.setNewFont(filename, ...)
	local OK, Font = pcall(_setNewFont, filename, ...)
	if OK then
		return Font
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, Font = pcall(_setNewFont, FileData, ...)
		if OK then
			return Font
		end
	end
end

function love.sound.newDecoder(filename, ...)
	local OK, Decoder = pcall(_newDecoder, filename, ...)
	if OK then
		return Decoder
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, Decoder = pcall(_newDecoder, FileData, ...)
		if OK then
			return Decoder
		end
	end
end

function love.sound.newSoundData(filename, ...)
	local OK, SoundData = pcall(_newSoundData, filename, ...)
	if OK then
		return SoundData
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, SoundData = pcall(_newSoundData, FileData, ...)
		if OK then
			return SoundData
		end
	end
end

function love.audio.newSource(filename, ...)
	local OK, Source = pcall(_newSource, filename, ...)
	if OK then
		return Source
	end

	if type(filename) == "string" then
		local f = io.open(filename, "rb")
		if not f then
			return nil
		end

		local FileData = love.filesystem.newFileData(f:read("*a"), filename)
		f:close()
		if not FileData then
			return nil
		end

		local OK, Source = pcall(_newSource, FileData, ...)
		if OK then
			return Source
		end
	end
end
