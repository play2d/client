local TServer = {}
local TServerMetatable = {__index = TServer}
TServer.Type = "Server"

function Network.CreateUDPServer(Port)
	local Socket = socket.udp(); Socket:settimeout(0)
	if not Socket:setsockname("*", Port or 0) then
		return nil
	end
	
	local IP, Port = Socket:getsockname()
	local Server = {
		Socket = Socket,
		IP = IP,
		Port = Port,
		Connection = {},
	}
	return setmetatable(Server, TServerMetatable)
end

function TServer:GetConnection(IP, Port)
	if self.Connection[IP] then
		return self.Connection[IP][Port]
	end
end

function TServer:ReceiveFrom(Message, IP, Port)
	local Packets = {}
	local DeleteRequests = {}
	local Channels = {}
	repeat
		local Data
		Data, Message = Message:ReadByte()
		
		local IsReply = (Data % 1) == 0
		local IsReliable = (Data % 2) == 0
		local IsSequenced = (Data % 4) == 0
		local IsOpened = (Data % 8) == 0
		local IsClosed = (Data % 16) == 0
		local IsPing = (Data % 32) == 0
		local IsFragment = (Data % 64) == 0
		if IsReply then
			if IsPing then
				-- If it's a ping reply then compare it
			elseif IsClosed then
				-- The client now knows that the channel is closed
			elseif IsOpened then 
				-- The client now knows that the channel is opened
			else
				-- If it's a packet reply then check it
				local PacketID, FragmentID, ChannelLength, Channel
				PacketID, Message = Message:ReadShort()
				if IsFragment then
					-- It looks like they're trying to delete a fragment of this packet, let's just do it
					FragmentID, Message = Message:ReadByte()
				end
				
				ChannelLength, Message = Message:ReadByte()
				Channel, Message = Message:ReadString(ChannelLength)
			end
		else
			if IsPing then
				-- If it's a ping then add it to the reply-queue
			else
				-- If it's a packet then process it
				if IsClosed then
					-- They're trying to close a connection, let's tell them we're going to close it
				elseif IsOpened then
					-- They're trying to open a connection, let's let them receive replies from us on this channel
				end
				
				if IsFragment then
				end
			end
		end
	until #Message == 0
end

function TServer:Receive()
	local Message, IP, Port = self.Socket:ReceiveFrom()
	if Message then
		local MessageData, Message = Message:ReadByte()
		MessageData = MessageData + 1
		
		local Compressed = (MessageData % 1) == 0
		local ZLibAvailable = (MessageData % 2) == 0
		
		if Compressed then
			-- Most clients will have zlib, but php plugins trying to connect probably won't have it.
			Message = table.concat(zlib.inflate(Message, {}, nil, "zlib"))
		end
		self:ReceiveFrom(Message, IP, Port)
		
		local Connection = self:GetConnection(IP, Port)
		if Connection then
			Connection.ZLib = ZLibAvailable
		end
		return true
	end
end

function TServer:Send()
end

function TServer:Update()
	repeat until not self:Receive()
	self:Send()
end