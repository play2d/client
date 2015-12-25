--[[
local love_video_newVideoStream = love.video.newVideoStream

function love.video.newVideoStream(...)
	local Success, VideoStream = pcall(love_video_newVideoStream, ...)
	if Success then
		return VideoStream
	end
	
	local FileName = ...
	local File = io.open(FileName, "rb")
	if File then
		
		local FileData = love.filesystem.newFileData(File:read("*a"), FileName)
		File:close()
		
		if FileData then
			return love_video_newVideoStream(FileData)
		end
	end
end
]]