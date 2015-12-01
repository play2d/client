local Transfer = Core.Transfer

Core.Network.Protocol[CONST.NET.SERVERTRANSFER] = function (Peer, Message)
	if Peer == Core.Connect.Request then
		local Stage, Message = Message:ReadByte()

		if Stage == CONST.NET.STAGE.CONNECTING then
			-- Transfer list
			Response = ("")
				:WriteShort(CONST.NET.SERVERTRANSFER)
				:WriteByte(CONST.NET.STAGE.CONNECTING)
			
			while #Message > 0 do
				local FilePath, FileSize, FileMD5Hash
				
				FilePath, Message = Message:ReadLine()
				FileSize, Message = Message:ReadInt()
				FileMD5Hash, Message = Message:ReadLine()
				
				if Transfer.Filter(FilePath, nil, nil) then
					Response = Response:WriteLine(FilePath, FileSize, FileMD5Hash)
				end
			end
			
			Interface.Connecting.Transfer.Panel:Show()
			Interface.Connecting.Transfer.Label:SetText(Lang.Get("gui_connecting_files"))
			
			Peer:send(Response, CONST.NET.CHANNELS.CONNECTING, "reliable")
		elseif Stage == CONST.NET.STAGE.GETFILENAME then
			local FilePath, Message = Message:ReadLine()
			local FileSize, Message = Message:ReadInt()
			local FileMD5Hash, Message = Message:ReadLine()
			
			if Core.Transfer.File then
				Core.Transfer.File:close()
				Core.Transfer.File = nil
				Core.Transfer.FilePath = nil
				Core.Transfer.FileSize = nil
			end
			
			if not Transfer.Filter(FilePath, FileSize, FileMD5Hash) then
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