Core.Network.Protocol[CONST.NET.SERVERINFO] = function (Peer, Message)
	local Version, Message = Message:ReadLine()
	local ServerName, Message = Message:ReadLine()
	local MapName, Message = Message:ReadLine()
	local GameMode, Message = Message:ReadLine()
	local Web, Message = Message:ReadLine()
	local PlayerCount, Message = Message:ReadByte()
	local MaxPlayers, Message = Message:ReadByte()
	
	-- if not is connected to this server then
		Peer:disconnect_later()
	--end
end
