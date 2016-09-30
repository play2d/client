local Path, PLAY2D = ...
local json = PLAY2D.JSON
local Master = {}

Master.Login = {
	
	User = "",
	Password = "",
	
}

function Master.load()
	
	Master.Socket = PLAY2D.Connection.CreateServer(PLAY2D.Commands.List["masterport"]:GetInt())
	Master.Connect()
	
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
		
	end
	
	function Master.Peer:OnDisconnect()
		
		PLAY2D.Print("Disconnected from master server", 200, 0, 0, 255)
		
		Master.Peer = nil
		
	end
	
end

function Master.LoadLogin()
	
	local LoginFile = love.filesystem.newFileData("sys/login.data")
	
	if LoginFile then
		
		local LoginData = love.math.decompress(LoginFile, "zlib")
		local Ok, Login = pcall(json.decode, LoginData)
		
		if Ok then
			
			Master.Login.User = type(Login.User) == "string" and Login.User or ""
			Master.Login.Password = type(Login.Password) == "string" and Login.Password or ""
			
		end
		
	end
	
end

function Master.SaveLogin()
	
	local LoginFile = love.filesystem.newFile("sys/login.data", "w")
	
	if LoginFile then
		
		local Login = json.encode(Master.Login)
		local LoginData = love.math.compress(Login, "zlib")
		
		if LoginData then
			
			LoginFile:write(LoginData:getString())
			
		end
		
		LoginFile:close()
		
	end
	
end

return Master