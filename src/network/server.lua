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
		Protocol = {},
	}
	return setmetatable(Server, TServerMetatable)
end

function TServer:SetProtocol(ID, Receive, Accept, Timeout)
	self.Protocol[ID] = {
		Receive = Receive,
		Accept = Accept,
		Timeout = Timeout
	}
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
		
		-- I'm not really sure if you can send a byte 256 but I'll add this anyway
		Data = Data + 1
		
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
				
				Connection.Ping.Received = {
					Key = Ping,
					When = socket.gettime(),
				}
			elseif IsClosed then
				-- The client now knows that the channel is closed
				
				local ChannelLength, ChannelName
				ChannelLength, Message = Message:ReadByte()
				ChannelName, Message = Message:ReadString(ChannelLength)
				
				local Channel = Connection.Channel[ChannelName]
				if Channel then
					
					-- Channel exists
					if Channel.Closing then
						Connection.Channel[ChannelName] = nil
					else
						self:Log("ATTEMPT TO CLOSE CHANNEL "..Channel.." NO CLOSE REQUEST SENT")
					end
				else
					self:Log("ATTEMPT TO CLOSE CHANNEL "..Channel.." IT DOES NOT EXIST")
				end
			elseif IsOpened then 
				-- The client now knows that the channel is opened
				local ChannelLength, ChannelName
				ChannelLength, Message = Message:ReadByte()
				ChannelName, Message = Message:ReadString(ChannelLength)
				
				local Channel = Connection.Channel[ChannelName]
				if Channel then
					
					-- Channel exists
					if Channel.Closing then
						self:Log("ATTEMPT TO OPEN A CLOSING CHANNEL "..Channel)
					else
						Channel.Open = true
					end
				else
					self:Log("ATTEMPT TO OPEN CHANNEL "..Channel.." NO OPEN REQUEST SENT")
				end
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
					-- If the packet length is higher than zero, there's a message
					PacketData, Message = Message:ReadString(PacketLength)
				end
				local Packet = Channel:GetPacket(PacketID, IsOpened, IsReliable, IsSequenced)
				
				Packet.Reliable = Reliable
				Packet.Sequenced = Sequenced
				Packet.Reply = true
				
				if IsFragment then
					-- This packet is fragmented into smaller pieces
					
					-- Get the current fragment
					local FragmentID, FragmentCount
					FragmentID, Message = Message:ReadByte()
					FragmentCount, Message = Message:ReadByte()
					
					if not Packet.Processed then
						
						-- It's necessary to confirm the received pieces of packets on the other side of the network
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
								
								if IsCompressed then
									-- Compression + fragmentation, zlib.inflate eventually triggers Lua errors so pcall
									local Success, Memory = pcall(zlib.inflate, Packet.Fragment, {}, nil, "zlib")
									if not Success then
										return self:Log("FAILED TO INFLATE FRAGMENTED PACKET (#"..PacketID..") FROM "..IP..":"..Port)
									end
									Packet.Data = table.concat(Memory)
								else
									-- No compression + fragmentation
									Packet.Data = table.concat(Packet.Fragment)
								end
								Packet.Fragment = nil
								Packet.Complete = true
							end
						end
					end
				elseif IsCompressed then
					-- Compression + no fragmentation
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
					-- If this is a close request, we must process all packets
					local ProcessedPacket = self:ProcessNextPacket()
					repeat
						ProcessedPacket = self:ProcessNextPacket()
					until not ProcessedPacket
					
					-- Once all the packets are processed, close the channel
					Connection:CloseChannel(ChannelName)
				end
			end
		end
	until #Message == 0
end

function TServer:GetNextReceivedPacket()
	for IP, ConnectionList in pairs(self.Connection) do
		for Port, Connection in pairs(ConnectionList) do
			local Packet = Connection:GetNextReceivedPacket()
			if Packet then
				return Packet
			end
		end
	end
end

function TServer:ProcessNextPacket()
	local Packet = self:GetNextReceivedPacket()
	if Packet then
		-- We need some callback functions that will read this packet
		
		return Packet
	end
end

function TServer:Receive()
	local Message, IP, Port = self.Socket:ReceiveFrom()
	if Message then
		local MessageData, Message = Message:ReadByte()
		
		-- I'm not sure if you can send a byte 256 but I'll add this anyway
		MessageData = MessageData + 1
		
		local Compressed = (MessageData % 1) == 0
		local ZLibAvailable = (MessageData % 2) == 0
		
		if Compressed then
			-- Most clients will have zlib, but php plugins trying to connect probably won't have it.
			local Success, Memory = pcall(zlib.inflate, Message, {}, nil, "zlib")
			if Success then
				Message = table.concat(Memory)
			else
				self:Log("RECEIVED DAMAGED PACKET")
				Message = nil
			end
		end
		
		if Message then
			self:ReceiveFrom(Message, IP, Port)
			
			local Connection = self:GetConnection(IP, Port)
			if Connection then
				-- Some people might use scripts from PHP browsers to do this and they probably won't have ZLIB support
				Connection.ZLib = ZLibAvailable
			end
			return true
		end
	end
end

function TServer:Log(Text)
	print(Text)
end

function TServer:ReceiveLoop()
	repeat until not self:Receive()
end

function TServer:Send()
	local Time = socket.gettime()
	
	for IP, ConnectionList in pairs(self.Connection) do
		for Port, Connection in pairs(ConnectionList) do
			local Message = ""
			
			if not Connection.Ping.Send or (Time - Connection.Ping.Send.Created >= Connection.PingTimeAfterLastPing and Connection.Ping.Send.Received) then
				-- Check if we can make a new ping value

				Connection.Ping.Send = {
					Key = string.char(math.random(0, 255)) .. string.char(math.random(0, 255)) .. string.char(math.random(0, 255)) .. string.char(math.random(0, 255)),
					Created = socket.gettime()
				}
			end
			
			if not Connection.Ping.Send.Last or Time - Connection.Ping.Send.Last >= Connection.PingSleepTime then
				-- Check when the last ping sent was
				
				if #Message + #Connection.Ping.Send.Key + 2 < Connection.PacketMaxSize then
					Message = Message
						:WriteByte(32)
						:WriteByte(#Connection.Ping.Send.Key)
						:WriteString(Connection.Ping.Send.Key)
					
					Connection.Ping.Send.Last = Time
				end
			end
			
			if not Connection:IsFrozen() then
			end
		
			if #Message > 0 then
				local ByteModifier = 0
				
				if zlib then
					ByteModifier = ByteModifier + 2
					
					local Success, Memory = pcall(zlib.deflate, Message, {}, "zlib", 9)
					if Success then
						ByteModifier = ByteModifier + 1
						Message = table.concat(Memory)
					else
						self:Log("FAILED TO DEFLATE PACKET")
					end
				end
				
				self.Socket:sendto(string.char(ByteModifier) .. Message, IP, Port)
			end
		end
	end
end

function TServer:Update()
	self:ReceiveLoop()
	self:Send()
end