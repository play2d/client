local PLAY2D, Socket = ...
local CONST = PLAY2D.Constants
local Connection = PLAY2D.Connection

Socket.Protocol[CONST.NET.MASTER.LOGIN] = function (Host, Peer, Packet)
	
	local Response = Packet:ReadByte()
	
	if Response == CONST.NET.MASTER.LOGINSUCCESS then
		
		PLAY2D.Print("Correct login", 0, 200, 0, 255)
	
	elseif Response == CONST.NET.MASTER.LOGINBADUSERNAME then
		
		PLAY2D.Print("Wrong username", 200, 0, 0, 255)
		
	elseif Response == CONST.NET.MASTER.LOGINBADPASSWORD then
		
		PLAY2D.Print("Wrong password", 200, 0, 0, 255)
		
	end
	
end