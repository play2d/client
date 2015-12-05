local Path = ...

ffi = require("ffi")
socket = require("socket")
json = require(Path..".json")
require("lfs")
require("enet")

require(Path..".string")
require(Path..".table")
require(Path..".io")
require(Path..".coro")
require(Path..".console")

local LFS_DIR = lfs.dir
function lfs.dir(...)
	local Iterate, DirectoryMetatable = LFS_DIR(...)
	return function ()
		local Path = Iterate(DirectoryMetatable)
		while Path == "." or Path == ".." or Path == "..." do
			Path = Iterate(DirectoryMetatable)
		end
		return Path
	end
end
setfenv(lfs.dir, {LFS_DIR = LFS_DIR})