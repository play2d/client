local Path, PLAY2D, Connection = ...
local ENet = require("enet")

local Server = {}
local ServerMT = {__index = Server}

function Connection.CreateServer(Port, Channels)
	
	local Socket = ENet.host_create("localhost:"..Port, 256)
	
	if Socket then
		
		Socket:channel_limit(1000)
	
		local self = {
			
			Socket = Socket
			
		}
		
		setmetatable(self, ServerMT)
		
		self.Protocol = {}
		self.Connection = {}
		self.Queue = {}
		
		if PLAY2D.Print then
			
			PLAY2D.Print("UDP socket initialized using port " .. self:GetPort(), 0, 200, 0, 255)
			
		else
			
			print("UDP socket initialized using port " .. self:GetPort())
			
		end
		
		return self
		
	end
	
end

function ServerMT:__tostring()
	
	return self.Socket:get_socket_address()
	
end

function Server:Update()
	
	local Event
	
	repeat
		
		Event = self.Socket:service(0)
		
		if Event then
		
			if Event.type == "connect" then
				
				local Index = Event.peer:index()
				local Client = self.Connection[Index]
				
				if not Client then
					
					Client = Connection.CreateClient(Event.peer)
					
					self.Connection[Index] = Client
					
				end
				
				local Packets = Client.Queue
				
				Client.Queue = nil
				
				for _, Packet in pairs(Packets) do
					
					Client:Send(unpack(Packet))
					
				end
				
				Client:OnConnect()
				self:OnConnect(Client)
				
			elseif Event.type == "disconnect" then
				
				local Index = Event.peer:index()
				local Client = self.Connection[Index]
				
				self.Connection[Index] = nil
				
				Client:OnDisconnect()
				self:OnDisconnect(Client)
				
			elseif Event.type == "receive" then
				
				local ID = Event.data:byte(1)
				local Protocol = self.Protocol[ID]
				
				if Protocol then
					
					local Client = self.Connection[Event.peer:index()]
					local Packet = Connection.CreatePacket(Event.data:sub(2))
					
					Protocol(self, Client, Packet)
					
				end
				
			end
			
		end
		
	until not Event
	
	self.Socket:flush()
	
end

function Server:OnConnect(Client)
	
end

function Server:OnDisconnect(Client)
	
end

function Server:GetIP()
	
	return self.Socket:get_socket_address():match("(.+)%:")
	
end

function Server:GetPort()
	
	return tonumber(self.Socket:get_socket_address():match(":(%d+)")) or 0
	
end

function Server:Connect(...)
	
	local Peer = self.Socket:connect(...)
	
	if Peer then
		
		local Connection = Connection.CreateClient(Peer)
		
		self.Connection[Peer:index()] = Connection
		
		return Connection
		
	end
	
end

return Server