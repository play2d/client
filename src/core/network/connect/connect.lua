local Connect = Core.Connect

Core.Network.Protocol[CONST.NET.PLAYERCONNECT] = function (Peer, Message)
	if Peer == Connect.Request then
		local Response, Message = Message:ReadByte()
		local Function = Connect.Response[Response]
		if Response then
			Function(Peer, Message)
		end
	end
end

function Connect.ConnectTo(Address)
	if not Connect.Request then
		Connect.Stage = nil
		Connect.Request = Core.Network.Host:connect(Address, CONST.NET.CHANNELS.MAX)
	end
end

function Connect.Cancel()
	if Connect.Request then
		if Connect.Request:state() == "connected" then
			Connect.Request:disconnect_later()
		end
	end
	
	Connect.Stage = nil
	Connect.Request = nil
	
	Core.Transfer.Cancel()
	Interface.Connecting.Cancel()
end

function Core.Connect.Connected(Peer)
	if Connect.Request == Peer then
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

function Connect.Disconnected(Peer)
	if Connect.Request == Peer then
		Connect.Cancel()
	end
end

Hook.Add("ENetConnect", Connect.Connected)
Hook.Add("ENetDisconnect", Connect.Disconnected)