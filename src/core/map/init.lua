Core.Maps = {
	Format = {}
}

local Path = ...
require(Path..".format_base")
require(Path..".format_map")

function Core.Maps.Load(Path, FileFormat)
	local Format = Core.Maps.Format[FileFormat]
	local File = io.open(Path, "rb")
	
	print("Loading map '"..Path.."'")
	if File then
		local Load, Error = Format.Load(File)
		
		File:close()
		
		return Load, Error
	end
	
	return nil, "Unrecognized map format"
end
