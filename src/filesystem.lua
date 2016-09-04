local Path, PLAY2D = ...
local Filesystem = {}

function Filesystem.changeWorkingDir(Dir)
	PLAY2D.C.PHYSFS_setWriteDir(Dir)
	PLAY2D.C.PHYSFS_mount(Dir, nil, 0)
end

return Filesystem