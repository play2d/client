Core.Network.Protocol[CONST.NET.PLAYERCONNECT] = function (Peer, Message)
	if Peer == Core.Connect.Request then
		local Response, Message = Message:ReadByte()
		if Response == CONST.NET.CONMSG.IPBAN then
			local Time, Message = Message:ReadInt()
			local Reason, Message = Message:ReadLine()
			
			Interface.MainMenu:Show()
			Interface.Connecting.Menu:Hide()
			
			Interface.Connecting.Window:Hide()
			Interface.Connecting.ErrorWindow:Show()
			
			Interface.Connecting.ErrorWindow:Focus()
			
			Core.Connect.Request = nil
		elseif Response == CONST.NET.CONMSG.NAMEBAN then
			local Time, Message = Message:ReadInt()
			local Reason, Message = Message:ReadLine()
			
			Interface.MainMenu:Show()
			Interface.Connecting.Menu:Hide()
			
			Interface.Connecting.Window:Hide()
			Interface.Connecting.ErrorWindow:Show()
			Interface.Connecting.PasswordPanel:Show()
			
			Interface.Connecting.ErrorWindow:Focus()
			
			Core.Connect.Request = nil
		elseif Response == CONST.NET.CONMSG.LOGINBAN then
			local Time, Message = Message:ReadInt()
			local Reason, Message = Message:ReadLine()
			
			Interface.MainMenu:Show()
			Interface.Connecting.Menu:Hide()
			
			Interface.Connecting.Window:Hide()
			Interface.Connecting.ErrorWindow:Show()
			
			Interface.Connecting.ErrorWindow:Focus()
			
			Core.Connect.Request = nil
		elseif Response == CONST.NET.CONMSG.DIFVER then
			local Version, Message = Message:ReadLine()
			
			Interface.MainMenu:Show()
			Interface.Connecting.Menu:Hide()
			
			Interface.Connecting.Window:Hide()
			Interface.Connecting.ErrorWindow:Show()
			
			Interface.Connecting.ErrorWindow:Focus()
			
			Core.Connect.Request = nil
		elseif Response == CONST.NET.CONMSG.WRONGPASS then
			Interface.MainMenu:Show()
			Interface.Connecting.Menu:Hide()
			
			Interface.Connecting.Window:Hide()
			Interface.Connecting.ErrorWindow:Show()
			Interface.Connecting.Password.Panel:Show()
			Interface.Connecting.Password.Field:SetText("")
			
			Interface.Connecting.ErrorWindow:Focus()
		elseif Response == CONST.NET.CONMSG.SLOTUNAVAIL then
			Interface.MainMenu:Show()
			Interface.Connecting.Menu:Hide()
			
			Interface.Connecting.Window:Hide()
			Interface.Connecting.ErrorWindow:Show()
			
			Interface.Connecting.ErrorWindow:Focus()
			
			Core.Connect.Request = nil
		elseif Response == CONST.NET.CONMSG.ACCEPTED then
			-- Create a new state
			
			Interface.Connecting.Window:Show()
			Interface.Connecting.ErrorWindow:Hide()
		end
	end
end

Core.Connect = {}

function Core.Connect.ConnectTo(Address)
	Core.Connect.Request = Core.Network.Host:connect(Address, CONST.NET.CHANNELS.MAX)
end

function Core.Connect.Cancel()
	if Core.Connect.Request then
		if Core.Connect.Request:state() == "connected" then
			Core.Connect.Request:disconnect_later()
		end
	end
	
	Core.Connect.Request = nil
	Interface.Connecting.Cancel()
end

function Core.Connect.Connected(Peer)
	if Core.Connect.Request == Peer then
		local MicAddress = Core.Microphone.Server:get_socket_address()
		local MicIP, MicPort = MicAddress:match("(.+)%:(%d+)")
		
		local Request = ("")
			:WriteShort(CONST.NET.PLAYERCONNECT)
			:WriteLine(Config.CFG["name"])
			:WriteLine("")
			:WriteLine(game.VERSION)
			:WriteLine(Interface.Connecting.Password.Field:GetText())
			:WriteShort(tonumber(MicPort))
			
		Peer:send(Request, CONST.NET.CHANNELS.UNCONNECTED, "reliable")
	end
end

function Core.Connect.Disconnected(Peer)
	if Core.Connect.Request == Peer then
		Core.Connect.Cancel()
	end
end

Hook.Add("ENetConnect", Core.Connect.Connected)
Hook.Add("ENetDisconnect", Core.Connect.Disconnected)