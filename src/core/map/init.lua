Core.Maps.Format = {}

local Map = Core.Maps
local Path = ...

require(Path..".format_base")
require(Path..".format_map")

function Map.Load(Path, FileFormat)
	if not FileFormat then
		for FormatName, Format in pairs(Map.Format) do
			if Path:sub(-#FormatName):lower() == FormatName:lower() then
				FileFormat = FormatName
				break
			end
		end
	end
	
	local Format = Map.Format[FileFormat]
	local File = io.open(Path, "rb")
	
	print("Loading map '"..Path.."'")
	if File then
		if Format then
			local Load, Error = Format.Load(Path, File)
			File:close()
			return Load, Error
		elseif FileFormat then
			File:close()
			return nil, "Unrecognized map format: "..Format.." (#"..#FileFormat..")"
		else
			File:close()
			return nil, "Unrecognized map format"
		end
	end
	
	return nil, "File not found"
end