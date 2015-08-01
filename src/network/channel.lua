local TChannel = {}
local TChannelMetatable = {__index = TChannel}
TChannel.Type = "Channel"

function Network.CreateChannel()
	local Channel = {
		Received = {},
		Sending = {},
		CurrentReceived = 0,
	}
	return setmetatable(Channel, TChannelMetatable)
end

function TChannel:GetNextPacket()
	if self.Open then
		for PacketID, Packet in pairs(self.Received) do
			if not Packet.Processed then
				if Packet.Unsequenced then
					Packet.Processed = true
					return Packet
				end
				
				local Next = (self.CurrentReceived + 1) % 65536
				if PacketID == Next then
					Packet.Processed = true
					self.CurrentReceived = Next
					return Packet
				end
			end
		end
	end
end

function TChannel:GetPacket(ID)
	local Packet = self.Received[ID]
	if not Packet then
		Packet = Network.CreatePacket()
		Packet.ID = ID
		self.Received[ID] = Packet
	end
	return Packet
end