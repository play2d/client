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

function Client:OnConnect()
	
end

function Client:OnDisconnect()
	
end

function Client:Send(Type, Packet, ...)
	
	if self.Queue then
		
		table.insert(self.Queue, {Type, Packet, ...})
		
	else
		
		if type(Packet) == "table" then
			
			self.Peer:send(string.char(Type) .. Packet.Data, ...)
			
		else
			
			self.Peer:send(string.char(Type) .. Packet, ...)
			
		end
		
	end
	
end