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
	local ConnectionList = self.Connection[IP]
	if not ConnectionList then
		ConnectionList = {}
		self.Connection[IP] = ConnectionList
	end
	
	local Connection = ConnectionList[Port]
	if not Connection then
		Connection = Network.CreateConnection(IP, Port)
		ConnectionList[Port] = Connection
	end
	return Connection
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
		local IsCompressed = (Data % 128) == 0
		
		local Connection = self:GetConnection(IP, Port)
		
		if IsReply then
			if IsPing then
				-- If it's a ping reply then compare it
				local PingLength, Ping
				PingLength, Message = Message:ReadByte()
				Ping, Message = Message:ReadString(PingLength)
			elseif IsClosed then
				-- The client now knows that the channel is closed
			elseif IsOpened then 
				-- The client now knows that the channel is opened
			else
				-- If it's a packet reply then check it
				local PacketID, FragmentID, ChannelLength, ChannelName
				PacketID, Message = Message:ReadShort()
				if IsFragment then
					-- It looks like they're trying to delete a fragment of this packet, let's just do it
					FragmentID, Message = Message:ReadByte()
				end
				ChannelLength, Message = Message:ReadByte()
				ChannelName, Message = Message:ReadString(ChannelLength)
			end
		else
			if IsPing then
				-- If it's a ping then add it to the reply-queue
			else
				-- If it's a packet then process it
				local ChannelLength, ChannelName
				ChannelLength, Message = Message:ReadByte()
				ChannelName, Message = Message:ReadString(ChannelLength)
				local Channel = Connection:GetChannel(ChannelName)
				
				local PacketID, PacketType, PacketLength
				local PacketData = ""
				PacketID, Message = Message:ReadShort()
				PacketType, Message = Message:ReadShort()
				PacketLength, Message = Message:ReadShort()
				if #PacketLength > 0 then
					PacketData, Message = Message:ReadString(PacketLength)
				end
				local Packet = Channel:GetPacket(PacketID)
				
				Packet.Reply = true
				
				if IsOpened then
					Channel.Open = true
				end
				
				if IsFragment then
					local FragmentID, FragmentCount
					FragmentID, Message = Message:ReadByte()
					FragmentCount, Message = Message:ReadByte()
					if not Packet.Processed then
						-- It's necessary to confirm the received pieces of packets
						if not Packet.Confirm then
							Packet.Confirm = {}
						end
						Packet.Confirm[FragmentID] = true
						
						if not Packet.Complete then
							-- Completed packets do not need to overwrite pieces of it
							if not Packet.Fragment then
								Packet.Fragment = {}
							end
							Packet.Fragment[FragmentID] = PacketData
							
							if #Packet.Fragment == FragmentCount then
								-- We can put together all the fragments when they're complete
								
								-- Inflate eventually pushes errors
								local Success, Memory = pcall(zlib.inflate, Packet.Fragment, {}, nil, "zlib")
								if not Success then
									return self:Log("FAILED TO INFLATE FRAGMENTED PACKET (#"..PacketID..") FROM "..IP..":"..Port)
								end
								Packet.Data = table.concat(Memory)
								Packet.Fragment = nil
								Packet.Complete = true
							end
						end
					end
				elseif IsCompressed then
					if not Packet.Processed then
						-- Inflate eventually pushes errors
						local Success, Memory = pcall(zlib.inflate, PacketData, {}, nil, "zlib")
						if not Success then
							return self:Log("FAILED TO INFLATE PACKET (#"..PacketID..") FROM "..IP..":"..Port)
						end
						Packet.Data = table.concat(Memory)
					end
				elseif not Packet.Processed then
					-- No compression + no fragmentation
					Packet.Data = PacketData
				end
				
				if IsClosed then
					local ProcessedPacket = self:ProcessNextPacket()
					repeat
						ProcessedPacket = self:ProcessNextPacket()
					until not ProcessedPacket or ProcessedPacket == Packet
					Connection:CloseChannel(ChannelName)
				end
			end
		end
	until #Message == 0
end

function TServer:GetNextPacket()
	for IP, ConnectionList in pairs(self.Connection) do
		for Port, Connection in pairs(ConnectionList) do
			local Packet = Connection:GetNextPacket()
			if Packet then
				return Packet
			end
		end
	end
end

function TServer:ProcessNextPacket()
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

function TServer:Log(Text)
	print(Text)
end

function TServer:Send()
end

function TServer:Update()
	repeat until not self:Receive()
	self:Send()
end