Core.Connect.Response[CONST.NET.CONMSG.WRONGPASS] = function (Peer, Message)
	Core.Connect.Last = tostring(Peer)
	Core.Connect.Cancel()
	
	Interface.MainMenu:Show()

	Interface.Connecting.Menu:Hide()
	
	Interface.Connecting.Window:Hide()
	Interface.Connecting.ErrorWindow:Show()
	Interface.Connecting.Password.Panel:Show()
	Interface.Connecting.Password.Field:SetText("")
	
	Interface.Connecting.ErrorWindow:Focus()
end