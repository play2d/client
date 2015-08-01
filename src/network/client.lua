local TConnection = {}
local TConnectionMetatable = {__index = TConnection}
TConnection.Type = "Connection"

function Network.CreateConnection(IP, Port)
	local Connection = {
		Received = {},
		Sending = {},
	}
	return setmetatable(Connection, TConnectionMetatable)
end