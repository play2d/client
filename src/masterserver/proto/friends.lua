local PLAY2D, Socket = ...
local CONST = PLAY2D.Constants
local Connection = PLAY2D.Connection

Socket.Protocol[CONST.NET.MASTER.FRIENDS] = function (Host, Peer, Packet)
	
	local Friends = Packet:ReadInt16()
	
end