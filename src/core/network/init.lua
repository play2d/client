Core.Network = {}

local Path = ...

require(Path..".serverlist")

function Core.Network.Load()
	local Host, Error = Network.CreateUDPServer(0)
	if Host then
		Core.Network.Host = Host
		
		Host:SetProtocol(CONST.NET.SERVERINFO, Core.Network.ServerInfo, Core.Network.ServerInfoPong)
	else
		Console.Print("Failed to open socket: "..Error, 255, 0, 0, 255)
	end
	
	Core.Network.Load = nil
end

function Core.Network.Send()
	for i = 1, 50000 do
		Core.Network.Host:NewPacket(CONST.NET.SERVERINFO, "127.0.0.1", 15849, "#testchannel", true, true)
	end
end

function Core.Network.Update()
	if Core.Network.Host then
		Core.Network.Host:Update()
	end
end

Hook.Add("update", Core.Network.Update)
