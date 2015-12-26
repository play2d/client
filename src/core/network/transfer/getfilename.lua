local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.GETFILENAME] = function (Peer, Message)
	local FilePath, Message = Message:ReadLine()
	local FileSize, Message = Message:ReadInt()
	local FileMD5Hash, Message = Message:ReadLine()
	
	if Transfer.File then
		Transfer.File:close()
		Transfer.File = nil
	end
	
	Transfer.FilePath = FilePath
	Transfer.FileSize = FileSize
	
	if not Transfer.Filter(FilePath, FileSize, FileMD5Hash) then
		return nil
	end
	
	local File = Transfer.Open(FilePath)
	if File then
		Transfer.File = File
	end
	
	Interface.Connecting.Transfer.Label:SetText(Lang.Get2("gui_connecting_file", {FILENAME = FilePath, PERCENT = 0}))
end