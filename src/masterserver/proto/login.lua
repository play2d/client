local PLAY2D, Socket, Master = ...
local CONST = PLAY2D.Constants
local Connection = PLAY2D.Connection

Socket.Protocol[CONST.NET.MASTER.LOGIN] = function (Host, Peer, Packet)
	
	local Response = Packet:ReadByte()
	
	if Response == CONST.NET.MASTER.LOGINSUCCESS then
		
		Master.Logging = false
		Master.Logged = {}
		Master.Error = nil
		
		Master.Logged.User = Packet:ReadLine()
		
		PLAY2D.Print("Correct login", 0, 200, 0, 255)
	
	elseif Response == CONST.NET.MASTER.LOGINBADUSERNAME then
	
		Master.Logging = false
		Master.Logged = false
		Master.Error = CONST.NET.MASTER.LOGINBADUSERNAME
		
		PLAY2D.Print("Wrong username", 200, 0, 0, 255)
		
	elseif Response == CONST.NET.MASTER.LOGINBADPASSWORD then
		
		Master.Logging = false
		Master.Logged = false
		Master.Error = CONST.NET.MASTER.LOGINBADPASSWORD
		
		PLAY2D.Print("Wrong password", 200, 0, 0, 255)
		
	elseif Response == CONST.NET.MASTER.LOGINBANNED then
		
		Master.Logging = false
		Master.Logged = false
		Master.Error = CONST.NET.MASTER.LOGINBANNED
		
		PLAY2D.Print("Banned", 200, 0, 0, 255)
		
	end
	
end