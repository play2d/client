local Path, PLAY2D, Master = ...
local json = PLAY2D.JSON

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