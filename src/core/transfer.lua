local Transfer = Core.Transfer
Transfer.Formats = {}
Transfer.ForcedFormats = {}
Transfer.ProtectedFolders = {}

function Transfer.Initialize()
	Transfer.Cancel()
	
	Transfer.Scripts = {}
	Transfer.Entities = {}
	Transfer.PacketQueue = {}
end

function Transfer.Cancel()
	if Transfer.File then
		Transfer.File:close()
	end
	
	Transfer.File = nil
	Transfer.Scripts = nil
	Transfer.Entities = nil
	Transfer.PacketQueue = nil
end

function Transfer.Filter(Path, Size, MD5)
	local Find = Path:findany(Transfer.ProtectedFolders)
	if Find and Find == 1 then
		return false
	end
	
	local Type = Path:match(".+%p([%w|%_|%d]+)")
	if not table.find(Transfer.Formats, Type) then
		return false
	end
	
	if lfs.attributes(Path, "mode") == "file" then
		-- File exists, do a MD5 checksum
		local File = io.open(Path, "r")
		if File then
			local Content = ""
			while not File:eof() do
				Content = File:read("*a")
			end
			File:close()
			
			local Checksum = md5.sumhexa(Content)
			if Checksum == MD5 then
				return false
			end
		end
	end
	
	return true
end

function Transfer.Open(Path)
	local Folders = Path:split("%/")
	local FolderPath = ""
	for Index, Folder in pairs(Folders) do
		FolderPath = FolderPath .. Folder.."/"
		if lfs.attributes(FolderPath:sub(1, -2), "mode") ~= "directory" then
			if next(Folders, Index) then
				if not lfs.mkdir(FolderPath:sub(1, -2)) then
					return nil
				end
			end
		end
	end
	return io.open(Path, "wb")
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