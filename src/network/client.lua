local TConnection = {}
local TConnectionMetatable = {__index = TConnection}
TConnection.Type = "Connection"

function Network.CreateConnection(IP, Port)
	local Connection = {
		Channel = {},
		Ping = {},
	}
	return setmetatable(Connection, TConnectionMetatable)
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