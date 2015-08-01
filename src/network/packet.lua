local TPacket = {}
local TPacketMetatable = {__index = TPacket}
TPacket.Type = "Packet"

function Network.CreatePacket(Reliable, Sequenced)
end