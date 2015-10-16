Core.Network = {}

local Path = ...

function Core.Network.Load()
	local Host, Error = enet.host_create("localhost:0", 256, 0, CONST.NET.CHANNELS.MAX)
	if Host then
		Console.Print("Initialized UDP socket "..Host:get_socket_address(), 0, 255, 0, 255)
		Core.Network.Host = Host
	else
		Console.Print("Failed to open socket: "..Error, 255, 0, 0, 255)
	end
	
	Core.Network.Load = nil
end

function Core.Network.Update()
	if Core.Network.Host then
		local Event = Core.Network.Host:service()
		repeat
			Event = Core.Network.Host:service()
		until not Event
		
		Core.Network.Host:flush()
	end
end

Hook.Add("update", Core.Network.Update)
