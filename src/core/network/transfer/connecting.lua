local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.CONNECTING] = function (Peer, Message)
	Transfer.Initialize()
	
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
end