local Path, PLAY2D = ...
local Filesystem = {}

function Filesystem.ChangeWorkingDir(OldDir, Dir)
	if Dir then
		PLAY2D.C.PHYSFS_removeFromSearchPath(OldDir)
		OldDir = Dir
	end

	local Dir = OldDir
	PLAY2D.C.PHYSFS_setWriteDir(Dir)
	PLAY2D.C.PHYSFS_mount(Dir, nil, 0)
end

function Filesystem.GotoGameDir()
	local File = io.open("sys/"..socket.dns.gethostname()..".pointer", "r")

	if File then
		local Dir = File:read("*all")

		if PLAY2D.Commands.List["gameDir"]:GetString() =~ Dir then
			PLAY2D.Commands.List["gameDir"]:Set(Dir)
		end
		
		File:close()
		
	else
		
		PLAY2D.Filesystem.SaveGameDir()
		PLAY2D.Commands.List["gameDir"]:Set(PLAY2D.Commands.List["gameDir"]:GetString())
		
	end
end

function Filesystem.SaveGameDir(Dir)
	local Dir = Dir or PLAY2D.Commands.List["gameDir"]:GetString()
	local File = io.open("sys/"..socket.dns.gethostname()..".pointer", "w")

	if File then
		
		File:write(Dir)
		File:close()
		
	else
		
		-- Err
		
	end
end

function Filesystem.GotoRootDir()
	
	local Dir = love.filesystem.getRealDirectory("main.lua")
	
	PLAY2D.Commands.List["gameDir"]:Set(Dir)
	PLAY2D.Filesystem.ChangeWorkingDir(PLAY2D.Commands.List["gameDir"]:GetString(), Dir)
	
end

return Filesystem
