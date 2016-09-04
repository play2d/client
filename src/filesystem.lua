local Path, PLAY2D = ...
local Filesystem = {}

Filesystem.InGameDir = false

function Filesystem.ChangeWorkingDir(OldDir, Dir)
	if Dir and Filesystem.InGameDir then
		PLAY2D.C.PHYSFS_removeFromSearchPath(OldDir)
		OldDir = Dir
	end

	local Dir = OldDir
	PLAY2D.C.PHYSFS_setWriteDir(Dir)
	PLAY2D.C.PHYSFS_mount(Dir, nil, 0)
end

function Filesystem.GotoGameDir()
	Filesystem.InGameDir = true

	local File = io.open("sys/"..socket.dns.gethostname()..".pointer", "r")

	if File then

		local Dir = File:read("*all")

		if Dir ~= PLAY2D.Commands.List["gameDir"]:GetString() then
			PLAY2D.Commands.List["gameDir"]:Set(Dir)
		end
		
		File:close()
		
	else
		
		PLAY2D.Filesystem.SaveGameDir()
		PLAY2D.Commands.List["gameDir"]:Set(PLAY2D.Commands.List["gameDir"]:GetString())
		
	end
end

function Filesystem.ExitGameDir()
	Filesystem.InGameDir = false
	PLAY2D.C.PHYSFS_removeFromSearchPath(PLAY2D.Commands.List["gameDir"]:GetString())
end

function Filesystem.SaveGameDir(Dir)
	Filesystem.GotoRootDir()

	local Dir = Dir or PLAY2D.Commands.List["gameDir"]:GetString()
	local File = io.open("sys/"..socket.dns.gethostname()..".pointer", "w")

	if File then
		
		File:write(Dir)
		File:close()
		
	else
		
		-- Err
		
	end

	Filesystem.GotoGameDir()
end

function Filesystem.GotoRootDir()
	Filesystem.InGameDir = false
	local Dir = love.filesystem.getRealDirectory("main.lua")

	if Dir ~= PLAY2D.Commands.List["gameDir"]:GetString() then

		PLAY2D.Commands.List["gameDir"]:Set(Dir, true)

	end
	
end

return Filesystem