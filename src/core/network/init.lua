Core.Network.Protocol = {}

local Path = ...
local Network = Core.Network

-- Hooks
Hook.Create("ENetConnect")
Hook.Create("ENetDisconnect")

-- Master server messages

-- Server/Client messages
require(Path..".serverinfo")
require(Path..".connect")
require(Path..".transfer")
require(Path..".micrecord")

function Network.Load()
	local Host = enet.host_create("localhost:0", 512, CONST.NET.CHANNELS.MAX)
	if Host then
		Console.Print("Initialized UDP socket "..Host:get_socket_address(), 0, 255, 0, 255)
		Network.Host = Host
	else
		Console.Print("Failed to open socket", 255, 0, 0, 255)
	end
	
	Network.Load = nil
end

function Network.Update()
	if Network.Host then
		local Event = Network.Host:service(1)
		while Event do
			if Event.type == "receive" then
				local Message = Event.data
				local PacketType
				
				PacketType, Message = Message:ReadShort()
				local Function = Network.Protocol[PacketType]
				if Function then
					Function(Event.peer, Message)
				end
			elseif Event.type == "connect" then
				Hook.Call("ENetConnect", Event.peer)
			elseif Event.type == "disconnect" then
				Hook.Call("ENetDisconnect", Event.peer)
			end
			Event = Network.Host:service()
		end
		Network.Host:flush()
	end
end