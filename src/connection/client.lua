local Path, PLAY2D, Connection = ...

local Client = {}
local ClientMT = {__index = Client}

function Connection.CreateClient(Peer)
	
	local self = {
		
		Peer = Peer
		
	}
	
	return setmetatable(self, ClientMT)
	
end

function ClientMT:__tostring()
	
	return tostring(self.Peer)
	
end

function Client:OnDisconnect()
	
end

function Client:Send(Packet, Channel, Flag)
	
	self.Peer:send(Packet.Data, Channel, Flag)
	
end