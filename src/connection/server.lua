local Path, PLAY2D, Connection = ...
local ENet = require("enet")

local Server = {}
local ServerMT = {__index = Server}

function Connection.CreateServer(Port, Peers, Channels)
	
	local self = {
		
		Socket = ENet.host_create(Port, Peers or 64, 0, Channels or 1, 0)
		
	}
	
	self.Protocol = {}
	self.Connection = {}
	
	return setmetatable(self, ServerMT)
	
end

function ServerMT:__tostring()
	
	return self.Socket:get_socket_address()
	
end

function Server:Update()
	
	local Event
	
	repeat
		
		Event = self.Socket:service()
		
		if Event.type == "connect" then
			
			local Client = Connection.CreateClient(Event.peer)
			
			self.Connection[Event.peer:index()] = Client
			self:OnConnected(Client)
			
		elseif Event.type == "disconnect" then
			
			local Index = Event.peer:index()
			
			self.Connection[Index]:OnDisconnect()
			self.Connection[Index] = nil
			
		elseif Event.type == "receive" then
			
			local ID = Event.data:byte(1)
			local Protocol = self.Protocol[ID]
			
			if Protocol then
			
				local Connection = self.Connection[Event.peer:index()]
				local Packet = Connection.CreatePacket(Event.data:sub(2))
				
				Protocol(self, Connection, Packet)
				
			end
			
		end
		
	until not Event
	
	self.Socket:flush()
	
end

function Server:OnConnected(Client)
	
end

return Server