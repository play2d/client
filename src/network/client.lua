local TConnection = {}
local TConnectionMetatable = {__index = TConnection}
TConnection.Type = "Connection"
TConnection.PingSleepTime = 500
TConnection.PingTimeAfterLastPing = 5000
TConnection.PingTimeBeforeFreeze = 2000
TConnection.PingTimeBeforeDisconnect = 40000
TConnection.PacketMaxSize = 5000
TConnection.PacketMaxDelay = 500

function Network.CreateConnection(IP, Port)
	local Connection = {
		Channel = {},
		Ping = {},
	}
	return setmetatable(Connection, TConnectionMetatable)
end

function TConnection:GeneratePing()
	local Length = math.random(3, 8)
	local Key = ""
	for i = 1, Length do
		Key = Key .. string.char(math.random(0, 255))
	end
	return Key
end

function TConnection:GetPing()
	return self.Ping.Value or 0
end

function TConnection:IsFrozen()
	if not self.Ping.Send then
		return false
	end
	
	-- If a ping was received, the connection is obviously not frozen
	if not self.Ping.Send.Received then
		-- When it has taken more than (self.PingTimeBeforeFreeze) to be received, the connection will be frozen so network is not wasted
		return socket.gettime() * 1000 - self.Ping.Send.Created >= self.PingTimeBeforeFreeze
	end
	return false
end

function TConnection:GetPacketMaxDelay()
	if self.Ping.Value then
		return math.min(self.Ping.Value + 15, self.PacketMaxDelay)
	end
	return self.PacketMaxDelay
end

function TConnection:CreateChannel(Name)
	local Channel = Network.CreateChannel()
	self.Channel[Name] = Channel
	return Channel
end

function TConnection:GetChannel(Name)
	return self.Channel[Name] or self:CreateChannel(Name)
end

function TConnection:CloseChannel(Name)
	self.Channel[Name] = nil
end

function TConnection:GetNextReceivedPacket()
	for Name, Channel in pairs(self.Channel) do
		local Packet = Channel:GetNextReceivedPacket()
		if Packet then
			return Packet
		end
	end
end