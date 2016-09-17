local Path, PLAY2D = ...
local Filesystem = {}

Filesystem.Paths = {}

function Filesystem.load()
	
	local LFS = love.filesystem

	Filesystem.Paths.RootDir = (LFS.isFused() and LFS.getSourceBaseDirectory()) or LFS.getRealDirectory("main.lua")

	Filesystem.ExitDir(Filesystem.Paths.RootDir)
	Filesystem.ExitDir(LFS.getSaveDirectory())

	-- Don't remove this line, makes the root directory have priority over others
	Filesystem.GotoDir(Filesystem.Paths.RootDir)
	
end

function Filesystem.GotoDir(Dir)
	
	PLAY2D.C.PHYSFS_setWriteDir(Dir)
	PLAY2D.C.PHYSFS_mount(Dir, nil, 0)
	
end

function Filesystem.ExitDir(Dir)
	
	PLAY2D.C.PHYSFS_removeFromSearchPath(Dir)
	
end

function Filesystem.GetGameDir()
	
	local LFS = love.filesystem
	local FilePath = "sys/"..socket.dns.gethostname()..".cfg"
	local File = LFS.newFile(FilePath, "r")

	if File then
		
		local Path = File:read()
		File:close()

		return Path

	else
		
		local File = LFS.newFile(FilePath, "w")

		if File then
			File:write(LFS.getSaveDirectory())
			File:close()
		end
		
		return

	end
end

function Filesystem.GotoGameDir()
	
	Filesystem.GotoDir(PLAY2D.Commands.List["gameDir"]:GetString())
	
end

function Filesystem.ExitGameDir()
	
	Filesystem.ExitDir(PLAY2D.Commands.List["gameDir"]:GetString())
	
end

return Filesystem
