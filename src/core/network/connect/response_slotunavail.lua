Core.Connect.Response[CONST.NET.CONMSG.SLOTUNAVAIL] = function (Peer, Message)
	Interface.MainMenu:Show()
	Interface.Connecting.Menu:Hide()
	
	Interface.Connecting.Window:Hide()
	Interface.Connecting.ErrorWindow:Show()
	
	Interface.Connecting.ErrorWindow:Focus()
	
	Core.Connect.Request = nil
end