local Path, PLAY2D, Connection = ...

local Client = {}
local ClientMT = {__index = Client}

function Connection.CreateClient(Peer)
	
	local self = {
		
		Peer = Peer,
		Queue = {},
		
	}
	
	return setmetatable(self, ClientMT)
	
end

function ClientMT:__tostring()
	
	return tostring(self.Peer)
	
end

function Client:OnDisconnect()
	
end

function Client:Send(Packet, ...)
	
	if self.Queue then
		
		table.insert(self.Queue, {Packet, ...})
		
	else
		
		if type(Packet) == "table" then
			
			self.Peer:send(Packet.Data, ...)
			
		else
			
			self.Peer:send(Packet, ...)
			
		end
		
	end
	
end