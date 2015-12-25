local love_audio_newSource = love.audio.newSource

function love.audio.newSource(...)
	local Success, Source = pcall(love_audio_newSource)
	if Success then
		return Source
	end
	
	local FileName = ...
	local File = io.open(FileName, "rb")
	if File then
		
		local FileData = love.filesystem.newFileData(File:read("*a"), FileName)
		File:close()
		
		if FileData then
			
			return love_audio_newSource(FileData)
		end
		
	end
end