local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.GETFILE] = function (Peer, Message)
	if Transfer.File then
		local Size, Message = Message:ReadShort()
		local Part, Message = Message:ReadString(Size)
		local EndOf = Message:ReadByte() == 1
		
		Transfer.File:write(Part)
		Interface.Connecting.Transfer.Label:SetText(Lang.Get2("gui_connecting_file", {FILENAME = Transfer.FilePath, Percent = Transfer.File:seek("cur", 0)/Transfer.FileSize}))
		
		if EndOf then
			Transfer.File:close()
			
			local ConfirmMessage = ("")
				:WriteShort(CONST.NET.SERVERTRANSFER)
				:WriteByte(CONST.NET.STAGE.CONFIRM)
			Peer:send(ConfirmMessage, CONST.NET.CHANNELS.CONNECTING, "reliable")
		end
	end
end