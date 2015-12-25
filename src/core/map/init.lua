Core.Maps.Format = {}

local Map = Core.Maps
local Path = ...

require(Path..".format_base")
require(Path..".format_map")

function Map.Load(Path, FileFormat)
	local Format = Map.Format[FileFormat]
	local File = io.open(Path, "rb")
	
	print("Loading map '"..Path.."'")
	if File then
		local Load, Error = Format.Load(File)
		
		File:close()
		
		return Load, Error
	end
	
	return nil, "Unrecognized map format"
end
