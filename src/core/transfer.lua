Core.Transfer = {}

local Transfer = Core.Transfer
Transfer.Formats = {}
Transfer.ProtectedFolders = {}

function Transfer.Filter(Path, Size, MD5)
	local Find = Path:findany(Transfer.ProtectedFolders)
	if Find and Find == 1 then
		return false
	end
	
	local Type = Path:match(".+%p([%w|%_|%d]+)")
	if not table.find(Transfer.Formats,Type) then
		return false
	end
	
	if lfs.attributes(Path, "mode") == "file" then
	end
	
	return true
end

function Transfer.Load()
	local File = io.open("sys/core/transfer.lst", "rb")
	if File then
		local Content = File:read("*a")
		if #Content > 0 then
			local Decode = json.decode(Content)
			
			Transfer.Formats = Decode["Formats"] or {}
			Transfer.ForcedFormats = Decode["Forced Formats"] or {}
			Transfer.ProtectedFolders = Decode["Protected Formats"] or {}
		end
		File:close()
	end
	
	Transfer.Load = nil
end