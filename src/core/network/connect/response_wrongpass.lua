Core.Connect.Response[CONST.NET.CONMSG.WRONGPASS] = function (Peer, Message)
	Interface.MainMenu:Show()
	Interface.Connecting.Menu:Hide()
	
	Interface.Connecting.Window:Hide()
	Interface.Connecting.ErrorWindow:Show()
	Interface.Connecting.Password.Panel:Show()
	Interface.Connecting.Password.Field:SetText("")
	
	Interface.Connecting.ErrorWindow:Focus()
end