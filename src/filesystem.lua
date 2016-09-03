local Path, PLAY2D = ...
local Filesystem = {}

function Filesystem.changeWorkingDir(Dir)
	PLAY2D.C.PHYSFS_addToSearchPath(Dir, 1)
	PLAY2D.C.PHYSFS_setWriteDir(Dir)
end

return Filesystem