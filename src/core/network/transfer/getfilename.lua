local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.GETFILENAME] = function (Peer, Message)
	local FilePath, Message = Message:ReadLine()
	local FileSize, Message = Message:ReadInt()
	local FileMD5Hash, Message = Message:ReadLine()
	
	if Transfer.File then
		Transfer.File:close()
		Transfer.File = nil
		Transfer.FilePath = nil
		Transfer.FileSize = nil
	end
	
	if not Transfer.Filter(FilePath, FileSize, FileMD5Hash) then
		return nil
	end
	
	local File = Transfer.Open(FilePath)
	if File then
		Transfer.File = File
		Transfer.FilePath = FilePath
		Transfer.FileSize = FileSize
	end
	
	Interface.Connecting.Transfer.Label:SetText(Lang.Get2("gui_connecting_file", {FILENAME = FilePath, Percent = 0}))
end