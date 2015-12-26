Core.Connect.Response[CONST.NET.CONMSG.DIFVER] = function (Peer, Message)
	local Version, Message = Message:ReadLine()
	
	Interface.MainMenu:Show()
	Interface.Connecting.Menu:Hide()
	
	Interface.Connecting.Window:Hide()
	Interface.Connecting.ErrorWindow:Show()
	
	Interface.Connecting.ErrorWindow:Focus()
	
	Core.Connect.Request = nil
end