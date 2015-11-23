Core.Network.Protocol[CONST.NET.SERVERINFO] = function (Peer, Message)
	local Version, Message = Message:ReadLine()
	local ServerName, Message = Message:ReadLine()
	local MapName, Message = Message:ReadLine()
	local GameMode, Message = Message:ReadLine()
	local Web, Message = Message:ReadLine()
	local Password, Message = Message:ReadByte()
	local PlayerCount, Message = Message:ReadByte()
	local MaxPlayers, Message = Message:ReadByte()
	
	local Server = {
		Address = tostring(Peer),
		Version = Version,
		Name = ServerName,
		Map = MapName,
		Mode = GameMode,
		Web = Web,
		Password = Password == 1,
		Players = PlayerCount,
		MaxPlayers = MaxPlayers,
		Ping = Peer:round_trip_time(),
	}
	Interface.Servers.AddServer(Server)
	
	-- if not is connected to this server then
		Peer:disconnect_later()
	--end
end
