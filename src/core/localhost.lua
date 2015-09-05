function game.core.LoadLocalHost()
	game.Host = Network.CreateUDPServer(100)
	
	game.core.LoadLocalHost = nil
end

function game.core.UpdateLocalHost()
	game.Host:Update()
end

Hook.Add("update", game.core.UpdateLocalHost)