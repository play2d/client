local Transfer = Core.Transfer
Transfer.Formats = {}
Transfer.ProtectedFolders = {}

function Transfer.Initialize()
	Transfer.Cancel()
	
	Transfer.Files = {}
	Transfer.Entities = {}
	Transfer.Players = {}
	Transfer.PacketQueue = {}
end

function Transfer.Cancel()
	if Transfer.File then
		Transfer.File:close()
	end
	
	Transfer.File = nil
	Transfer.Files = nil
	Transfer.Entities = nil
	Transfer.Players = nil
	Transfer.PacketQueue = nil
end

function Transfer.GetScripts()
	local Files = {}

	for _, File in pairs(Transfer.Files) do
		local Type = File:match(".+%p([%w|%_|%d]+)")
		if Type == "lua" then
			table.insert(Files, File)
		end
	end
	
	local Scripts = {
		Autorun = {},
		Entities = {},
	}
	
	for _, File in pairs(Files) do
		if File:find("src/entities/[%w|%_|%d]+%plua") == 1 or File:find("addons/[%w|%_|%d]+/lua/entities/[%w|%_|%d]+%plua") == 1 then
			table.insert(Scripts.Entities, File)
		elseif File:find("addons/[%w|%_|%d]+/lua/autorun/cl_[%w|%_|%d]+.lua") == 1 or File:find("addons/[%w|%_|%d]+/lua/autorun/sh_[%w|%_|%d]+%plua") == 1 then
			table.insert(Scripts.Autorun, File)
		end
	end
	
	return Scripts
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
		-- File already exists
		
		if lfs.attributes(Path, "size") == Size then
			-- File has the same size, it might have the same contents

			local File = io.open(Path, "rb")
			if File then
				local Content = ""
				while not File:eof() do
					Content = File:read("*a")
				end
				File:close()
				
				local Checksum = md5.sumhexa(Content)
				if Checksum == MD5 then
					-- File has the same contents, no need to resend
					return false
				end
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
			Transfer.ProtectedFolders = Decode["Protected Formats"] or {}
		end
		File:close()
	end
	
	Transfer.Load = nil
end