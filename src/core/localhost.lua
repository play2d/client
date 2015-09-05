function game.core.LoadLocalHost()
	game.Host = Network.CreateUDPServer(100)
	
	game.core.LoadLocalHost = nil
end

function game.core.UpdateLocalHost()
	if game.Host then
		game.Host:Update()
	end
end

Hook.Add("update", game.core.UpdateLocalHost)