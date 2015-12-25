local Path = ...

ffi = require("ffi")
socket = require("socket")
json = require(Path..".json")
md5 = require(Path..".md5")
require("lfs")
require("enet")

ffi.NULL = ffi.new("void *")
ffi.TRUE = ffi.new("bool", true)
ffi.FALSE = ffi.new("bool", false)

require(Path..".string")
require(Path..".table")
require(Path..".io")
require(Path..".wrapper")
require(Path..".console")
require(Path..".lua")

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