Core.Connect.Response[CONST.NET.CONMSG.LOGINBAN] = function (Peer, Message)
	local Time, Message = Message:ReadInt()
	local Reason, Message = Message:ReadLine()
	
	Interface.MainMenu:Show()
	Interface.Connecting.Menu:Hide()
	
	Interface.Connecting.Window:Hide()
	Interface.Connecting.ErrorWindow:Show()
	
	Interface.Connecting.ErrorWindow:Focus()
	
	Core.Connect.Request = nil
end