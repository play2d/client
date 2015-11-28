Core.Transfer = {}
Core.Transfer.Formats = {}
Core.Transfer.ProtectedFolders = {}

Core.Network.Protocol[CONST.NET.SERVERTRANSFER] = function (Peer, Message)
	if Peer == Core.Connect.Request then
		local Stage, Message = Message:ReadByte()

		if Stage == CONST.NET.STAGE.CONNECTING then
			-- Transfer list
			Response = ("")
				:WriteShort(CONST.NET.SERVERTRANSFER)
				:WriteByte(CONST.NET.STAGE.CONNECTING)
			
			while #Message > 0 do
				local FilePath; FilePath, Message = Message:ReadLine()
				local _, FileType = FilePath:match("(.+)%p([%w|%_|%d]+)")
				local Find = FilePath:findany(Core.Transfer.ProtectedFolders)
				local Filter
				
				if Find and Find == 1 then
					Filter = true
				elseif love.filesystem.isFile(FilePath) and FileType ~= "lua" then
					Filter = true
				elseif not table.find(Core.Transfer.Formats, FileType) then
					Filter = true
				end
				
				if not Filter then
					Response = Response:WriteLine(FilePath)
				end
			end
			
			Interface.Connecting.Transfer.Panel:Show()
			Interface.Connecting.Transfer.Label:SetText(Lang.Get("gui_connecting_files"))
			
			Peer:send(Response, CONST.NET.CHANNELS.CONNECTING, "reliable")
		elseif Stage == CONST.NET.STAGE.GETFILENAME then
			local FilePath, Message = Message:ReadLine()
			local FileSize, Message = Message:ReadInt()
			local Find = FilePath:findany(Core.Transfer.ProtectedFolders)
			
			if Core.Transfer.File then
				Core.Transfer.File:close()
				Core.Transfer.File = nil
				Core.Transfer.FilePath = nil
				Core.Transfer.FileSize = nil
			end
			
			if Find and Find == 1 then
				return nil
			elseif not table.find(Core.Transfer.Formats, FileType) then
				return nil
			end
			
			local File = io.open(FilePath, "wb")
			if File then
				Core.Transfer.File = File
				Core.Transfer.FilePath = FilePath
				Core.Transfer.FileSize = FileSize
			end
		
			Interface.Connecting.Transfer.Label:SetText(Lang.Get2("gui_connecting_file", {FILENAME = FilePath, Percent = 0}))
		elseif Stage == CONST.NET.STAGE.GETFILE then
			if Core.Transfer.File then
				local Size, Message = Message:ReadShort()
				local Part, Message = Message:ReadString(Size)
				
				Core.Transfer.File:write(Part)
				Interface.Connecting.Transfer.Label:SetText(Lang.Get2("gui_connecting_file", {FILENAME = Core.Transfer.FilePath, Percent = Core.Transfer.File:seek("cur", 0)/Core.Transfer.FileSize}))
			end
			
		elseif Stage == CONST.NET.STAGE.GETSTATE then
			if Core.Transfer.File then
				Core.Transfer.File:close()
				Core.Transfer.File = nil
				Core.Transfer.FilePath = nil
				Core.Transfer.FileSize = nil
			end
			
			Interface.Connecting.Transfer.Panel:Hide()
			Interface.Connecting.State:Show()
		end
	end
end

function Core.Transfer.Load()
	local File = io.open("sys/core/transferformats.lst", "rb")
	if File then
		local Content = File:read("*a")
		if #Content > 0 then
			Core.Transfer.Formats = json.decode(Content)
		end
		File:close()
	end
	
	local File = io.open("sys/core/transferprotfolders.lst", "rb")
	if File then
		local Content = File:read("*a")
		if #Content > 0 then
			Core.Transfer.Formats = json.decode(Content)
		end
		File:close()
	end
	Core.Transfer.Load = nil
end