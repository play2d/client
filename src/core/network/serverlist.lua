function Core.Network.ServerInfo(Host, Packet)
end

function Core.Network.ServerInfoPong(Host, Packet)
	print("RECEIVED PONG FOR PACKET ID: "..Packet.ID)
end