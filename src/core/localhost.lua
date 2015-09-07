function game.core.LoadLocalHost()
	local Host, Error = Network.CreateUDPServer(100)
	if Host then
		game.Host = Host
	else
		game.Console.Print("Failed to open socket: "..Error, 255, 0, 0, 255)
	end
	
	game.core.LoadLocalHost = nil
end

function game.core.UpdateLocalHost()
	if game.Host then
		game.Host:Update()
	end
end

Hook.Add("update", game.core.UpdateLocalHost)