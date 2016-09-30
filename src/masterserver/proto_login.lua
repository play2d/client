local Path, PLAY2D, Master = ...
local CONST = PLAY2D.Constants
local Connection = PLAY2D.Connection

function Master.LoginAttempt()
	
	local Packet = Connection.CreatePacket()
	
	Packet:WriteLine(Master.Login.User)
	Packet:WriteLine(Master.Login.Password)
	
	Master.Peer:Send(CONST.NET.MASTER.LOGIN, Packet)
	
end

function Master.HandleLogin(Host, Peer, Packet)
	
	local Bits = self:Read8Bits()
	local Success = Bits[1]
	local WrongUsername = Bits[2]
	local WrongPassword = Bits[3]
	
	if Success then
		
		PLAY2D.Print("Correct login", 0, 200, 0, 255)
	
	elseif WrongUsername then
		
		PLAY2D.Print("Wrong username", 200, 0, 0, 255)
		
	elseif WrongPassword then
		
		PLAY2D.Print("Wrong password", 200, 0, 0, 255)
		
	end
	
end