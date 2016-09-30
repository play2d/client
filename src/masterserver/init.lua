local Path, PLAY2D = ...
local Master = {}
local CONST = PLAY2D.Constants

PLAY2D.Require(Path.."/data", Master)
PLAY2D.Require(Path.."/proto_login", Master)

Master.Login = {
	
	User = "",
	Password = "",
	
}

function Master.load()
	
	Master.Socket = PLAY2D.Connection.CreateServer(PLAY2D.Commands.List["masterport"]:GetInt())
	Master.Connect()
	
	Master.Socket.Protocol[CONST.NET.MASTER.LOGIN] = Master.HandleLogin
	
	Master.load = nil
	
end

function Master.update()
	
	if Master.Socket then
		
		Master.Socket:Update()
		
	end
	
end

function Master.Connect()
	
	if Master.Peer then
		
		PLAY2D.Print("Closing already established connection", 200, 0, 0, 255)
		
		Master.Peer.Peer:disconnect()
		
	end
	
	PLAY2D.Print("Connecting to master server")
	
	Master.Peer = Master.Socket:Connect("localhost:45654")
	
	function Master.Peer:OnConnect()
		
		PLAY2D.Print("Connected to master server", 0, 200, 0, 255)
		
		-- Connected, log in
		Master.LoginAttempt()
		
	end
	
	function Master.Peer:OnDisconnect()
		
		PLAY2D.Print("Disconnected from master server", 200, 0, 0, 255)
		
		Master.Peer = nil
		
		PLAY2D.Print("Retrying...")
		Master.Connect()
		
	end
	
end

return Master