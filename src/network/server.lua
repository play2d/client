local TServer = {}
local TServerMetatable = {__index = TServer}
TServer.Type = "Server"
TServer.PacketsPerSecond = 33

function Network.CreateUDPServer(Port)
	local Socket, Error = socket.udp()
	if not Socket then
		return nil, Error
	end

	local Bind, Error = Socket:setsockname("*", Port or 0)
	if not Bind then
		return nil, Error
	end
	Socket:settimeout(0)

	local IP, Port = Socket:getsockname()
	local Server = {
		Socket = Socket,
		IP = IP,
		Port = Port,
		Connection = {},
		Protocol = {},
		
		Sent = socket.gettime() * 1000,
	}
	
	if Console then
		Console.Print("Initialized UDP socket using port "..Port, 0, 255, 0, 255)
	else
		print("Initialized UDP socket using port "..Port)
	end
	
	return setmetatable(Server, TServerMetatable)
end

function TServer:SetProtocol(ID, Receive, Accept, Timeout)
	self.Protocol[ID] = {
		Receive = Receive,
		Accept = Accept,
		Timeout = Timeout
	}
end

function TServer:NewPacket(TypeID, IP, Port, ChannelName, Reliable, Sequenced)
	local Connection = self:GetConnection(IP, Port)
	if not Connection then
		return nil
	end
	
	local Channel = Connection:GetChannel(ChannelName)
	if not Channel then
		return nil
	end
	return Channel:CreateNewPacket(TypeID, Reliable, Sequenced)
end

function TServer:PacketReceived(Packet)
	local Protocol = self.Protocol[Packet.TypeID]
	if Protocol then
		local Function = Protocol.Receive
		if Function then
			Function(self, Packet)
		end
	end
end

function TServer:PacketAccepted(Packet)
	local Protocol = self.Protocol[Packet.TypeID]
	if Protocol then
		local Function = Protocol.Accept
		if Function then
			Function(self, Packet)
		end
	end
end

function TServer:PacketTimeout(Packet)
	local Protocol = self.Protocol[Packet.TypeID]
	if Protocol then
		local Function = Protocol.Timeout
		if Function then
			Function(self, Packet)
		end
	end
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
	local Time = socket.gettime() * 1000
	local Packets = {}
	local DeleteRequests = {}
	local Channels = {}
	repeat
		local Data
		Data, Message = Message:ReadByte()

		local IsCompressed = Data >= 128; Data = Data % 128
		local IsFragment = Data >= 64; Data = Data % 64
		local IsPing = Data >= 32; Data = Data % 32
		local IsClosed = Data >= 16; Data = Data % 16
		local IsOpened = Data >= 8; Data = Data % 8
		local IsSequenced = Data >= 4; Data = Data % 4
		local IsReliable = Data >= 2; Data = Data % 2
		local IsReply = Data >= 1
		
		local Connection = self:GetConnection(IP, Port)
		if IsReply then
			if IsPing then
				-- If it's a ping reply then compare it
				local PingLength, Ping
				PingLength, Message = Message:ReadByte()
				Ping, Message = Message:ReadString(PingLength)

				if Connection.Ping.Send then
					if Connection.Ping.Send.Key == Ping then
						Connection.Ping.Send.Received = Time
						Connection.Ping.Value = (Time - Connection.Ping.Send.Last)/2
					end
				end
			else
				-- If it's a packet reply then check it
				local Channel, ChannelLength, ChannelName
				ChannelLength, Message = Message:ReadByte()
				ChannelName, Message = Message:ReadString(ChannelLength)
				Channel = Connection.Channel[ChannelName]
				
				if IsOpened then 
					-- The client now knows that the channel is opened

					if Channel then
						-- Channel exists
						
						if Channel.Closing then
							self:Log("ATTEMPT TO OPEN A CLOSING CHANNEL "..Channel)
						else
							Channel.Open = true
						end
					else
						self:Log("ATTEMPT TO OPEN CHANNEL "..ChannelName.." NO OPEN REQUEST SENT")
					end
				end

				if Channel then
					local PacketID, FragmentID
					PacketID, Message = Message:ReadShort()
					
					if IsFragment then
						-- It looks like they're trying to delete a fragment of this packet, let's just do it
						FragmentID, Message = Message:ReadByte()
						
						local Packet = Channel:GetCreatedPacket(PacketID, IsReliable, IsSequenced)
						if Packet then
							-- Make it check that the packet exists or the program could crash
							
							if Packet.Fragment then
								if Packet.FragmentID == FragmentID then
									Packet.FragmentID = next(Packet.Fragment, FragmentID)
								end
								
								Packet.Fragment[FragmentID] = nil
								if Packet.FragmentID == nil then
									Packet.FragmentID = next(Packet.Fragment)
									if Packet.FragmentID == nil then
										Packet.Fragment = nil
										Packet.FragmentCount = nil
										self:PacketAccepted(Packet)
										Channel:RemovePacket(PacketID, IsReliable, IsSequenced)
									end
								end
							else
								self:Log("RECEIVED ATTEMPT TO DELETE A PACKET FRAGMENT FROM A PACKET THAT DOESN'T EXIST (#"..PacketID..")")
							end
						else
							self:Log("RECEIVED ATTEMPT TO DELETE A FRAGMENTED PACKET THAT DOESN'T EXIST (#"..PacketID..")")
						end
					else
						local Packet = Channel:GetCreatedPacket(PacketID, IsReliable, IsSequenced)
						if Packet then
							self:PacketAccepted(Packet)
							Channel:RemovePacket(PacketID, IsReliable, IsSequenced)
						else
							self:Log("RECEIVED ATTEMPT TO CLOSE A PACKET THAT DOESN'T EXIST (#"..PacketID..")")
						end
					end
				else
					self:Log("ATTEMPT TO REMOVE PACKET FROM CHANNEL "..ChannelName..", PACKET DOES NOT EXIST (#"..PacketID..")")
				end
				
				if IsClosed then
					-- The client now knows that the channel is closed

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
				end
			end
		else
			if IsPing then
				-- If it's a ping then add it to the reply-queue
				local PingLength, Ping
				PingLength, Message = Message:ReadByte()
				Ping, Message = Message:ReadString(PingLength)
				
				Connection.Ping.Received = {
					Key = Ping,
					When = Time,
				}
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
				if PacketLength > 0 then
					-- If the packet length is higher than zero, there's a message
					PacketData, Message = Message:ReadString(PacketLength)
				end
				local Packet = Channel:GetNewPacket(PacketID, PacketType, IsOpened, IsReliable, IsSequenced)
				
				Packet.Channel = ChannelName
				Packet.First = IsOpened
				Packet.Reliable = IsReliable
				Packet.Sequenced = IsSequenced
				
				if IsReliable then
					Packet.Reply = true
				end
				
				if IsFragment then
					-- This packet is fragmented into smaller pieces
					
					-- Get the current fragment
					local FragmentID, FragmentCount
					FragmentID, Message = Message:ReadByte()
					FragmentCount, Message = Message:ReadByte()
					
					-- It's necessary to confirm the received pieces of packets on the other side of the network
					if IsReliable then
						if not Packet.Confirm then
							Packet.Confirm = {}
						end
						Packet.Confirm[FragmentID] = true
					end
					
					if not Packet.Processed and not Packet.Complete then
						
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
									return self:Log("FAILED TO INFLATE FRAGMENTED PACKET (#"..PacketID..") FROM "..IP..":"..Port.." ("..FragmentCount.." fragments)")
								end
								Packet.Buffer = table.concat(Memory)
							else
								-- No compression + fragmentation
								Packet.Buffer = table.concat(Packet.Fragment)
							end
							Packet.Fragment = nil
							Packet.Complete = true
						end
					else
						self:Log("RECEIVED DUPLICATED PACKET FRAGMENT (#"..PacketID..") FROM "..IP..":"..Port)
					end
				elseif IsCompressed then
					-- Compression + no fragmentation
					if not Packet.Processed then
						-- Inflate eventually pushes errors
						local Success, Memory = pcall(zlib.inflate, PacketData, {}, nil, "zlib")
						if not Success then
							return self:Log("FAILED TO INFLATE PACKET (#"..PacketID..") FROM "..IP..":"..Port)
						end
						Packet.Buffer = table.concat(Memory)
						Packet.Complete = true
					else
						self:Log("RECEIVED DUPLICATED COMPRESSED PACKET (#"..PacketID..") FROM "..IP..":"..Port)
					end
				elseif not Packet.Processed then
					-- No compression + no fragmentation
					Packet.Buffer = PacketData
					Packet.Complete = true
				else
					self:Log("RECEIVED DUPLICATED PACKET (#"..PacketID..") FROM "..IP..":"..Port)
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
		self:PacketReceived(Packet)
		return Packet
	end
end

function TServer:Receive()
	local Message, IP, Port = self.Socket:receivefrom()
	if Message then
		local MessageData, Message = Message:ReadByte()
		
		local ZLibAvailable = MessageData >= 2; MessageData = MessageData % 2
		local Compressed = MessageData >= 1
		
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
	local Time = socket.gettime() * 1000
	
	for IP, ConnectionList in pairs(self.Connection) do
		for Port, Connection in pairs(ConnectionList) do
			local Message = ""
			
			if not Connection.Ping.Send or (Time - Connection.Ping.Send.Created >= Connection.PingTimeAfterLastPing and Connection.Ping.Send.Received) then
				-- Check if we can make a new ping value

				Connection.Ping.Send = {
					Key = Connection:GeneratePing(),
					Created = Time
				}
			end
			
			if not Connection.Ping.Send.Received then
				-- If the ping was received there's no need to keep sending it
				
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
			end
			
			if Connection.Ping.Received then
				if #Message + #Connection.Ping.Received.Key + 2 < Connection.PacketMaxSize then
					Message = Message
						:WriteByte(33)
						:WriteByte(#Connection.Ping.Received.Key)
						:WriteString(Connection.Ping.Received.Key)
					
					Connection.Ping.Received = nil
				end
			end
			
			if not Connection:IsFrozen() then
				-- If the connection is frozen we don't need to waste resources on sending packets that might not be received, otherwise send them

				for ChannelName, Channel in pairs(Connection.Channel) do
					-- Check packets from all the channels
					
					local ChannelLength = #ChannelName
					
					-- Send packet replies
					local Received = Channel.Received
					
					for ID, Packet in pairs(Received.Reliable.Sequenced) do
						if type(ID) == "number" then
							if Packet.Confirm then
								for Part, _ in pairs(Packet.Confirm) do
									if #Message + ChannelLength + 5 < Connection.PacketMaxSize then
										Message = Message
											:WriteByte(Packet:GetModifier())
											:WriteByte(ChannelLength)
											:WriteString(ChannelName)
											:WriteShort(ID)
											:WriteByte(Part)
										
										Packet.Confirm[Part] = nil
										if not next(Packet.Confirm) then
											Packet.Confirm = nil
											Packet.Reply = nil
										end
									else
										break
									end
								end
							elseif Packet.Reply then
								if #Message + ChannelLength + 4 < Connection.PacketMaxSize then
									Message = Message
										:WriteByte(Packet:GetModifier())
										:WriteByte(ChannelLength)
										:WriteString(ChannelName)
										:WriteShort(ID)
									
									Packet.Reply = nil
								else
									break
								end
							end
						end
					end
					
					for ID, Packet in pairs(Received.Reliable.Unsequenced) do
						if type(ID) == "number" then
							if Packet.Confirm then
								for Part, _ in pairs(Packet.Confirm) do
									if #Message + ChannelLength + 5 < Connection.PacketMaxSize then
										Message = Message
											:WriteByte(Packet:GetModifier())
											:WriteByte(ChannelLength)
											:WriteString(ChannelName)
											:WriteShort(ID)
											:WriteByte(Part)
										
										Packet.Confirm[Part] = nil
										if not next(Packet.Confirm) then
											Packet.Confirm = nil
											Packet.Reply = nil
										end
									else
										break
									end
								end
							elseif Packet.Reply then
								
								if #Message + ChannelLength + 4 < Connection.PacketMaxSize then
									Message = Message
										:WriteByte(Packet:GetModifier())
										:WriteByte(ChannelLength)
										:WriteString(ChannelName)
										:WriteShort(ID)
									
									Packet.Reply = nil
								else
									break
								end
							end
						end
					end
					
					-- Send local packets
					local Sending = Channel.Sending

					for ID, Packet in pairs(Sending.Reliable.Sequenced) do
						if type(ID) == "number" then
							if not Packet.Sent or Time - Packet.Sent >= Connection.PacketMaxDelay then
								-- Check that this packet wasn't sent too short ago
								
								local IsCompressed, IsFragmented = Packet:GenerateCompression()
								
								if IsFragmented then
									-- Fragmented packets are a bit different from normal packets
									
									local Fragment = Packet.Fragment[Packet.FragmentID]
									if not Fragment then
										Packet.FragmentID = next(Packet.Fragment)
										Fragment = Packet.Fragment[Packet.FragmentID]
									end
									local FragmentLength = #Fragment

									if #Message + ChannelLength + FragmentLength + 10 < Connection.PacketMaxSize then
										-- Generate the packet header
										
										Message = Message
											:WriteByte(Packet:GetModifier())
											:WriteByte(ChannelLength)
											:WriteString(ChannelName)
											:WriteShort(ID)
											:WriteShort(Packet.TypeID)
											:WriteShort(FragmentLength)
											:WriteString(Fragment)
											
											-- Two extra bytes for fragmented packets.
											:WriteByte(Packet.FragmentID)
											:WriteByte(Packet.FragmentCount)
											
										Packet.Sent = Time
										Packet.FragmentID = next(Packet.Fragment, Packet.FragmentID) or next(Packet.Fragment)
									end
								else
									-- Normal packets are sent completely at once
									
									local CompressionLength = #Packet.Compression
									if #Message + ChannelLength + CompressionLength + 8 < Connection.PacketMaxSize then
										-- Generate the packet header
										
										Message = Message
											:WriteByte(Packet:GetModifier())
											:WriteByte(ChannelLength)
											:WriteString(ChannelName)
											:WriteShort(ID)
											:WriteShort(Packet.TypeID)
											:WriteShort(CompressionLength)
											:WriteString(Packet.Compression)
											
										Packet.Sent = Time
									end
								end
							end
						end
					end
					
					for ID, Packet in pairs(Sending.Reliable.Unsequenced) do
						if type(ID) == "number" then
							if not Packet.Sent or Time - Packet.Sent >= Connection.PacketMaxDelay then
								-- Check that this packet wasn't sent too short ago
								
								local IsCompressed, IsFragmented = Packet:GenerateCompression()
								if IsFragmented then
									-- Fragmented packets are a bit different from normal packets
									
									local Fragment = Packet.Fragment[Packet.FragmentID]
									if not Fragment then
										Packet.FragmentID = next(Packet.Fragment)
										Fragment = Packet.Fragment[Packet.FragmentID]
									end
									local FragmentLength = #Fragment
									
									if #Message + ChannelLength + FragmentLength + 10 < Connection.PacketMaxSize then
										-- Generate the packet header
										
										Message = Message
											:WriteByte(Packet:GetModifier())
											:WriteByte(ChannelLength)
											:WriteString(ChannelName)
											:WriteShort(ID)
											:WriteShort(Packet.TypeID)
											:WriteShort(FragmentLength)
											:WriteString(Fragment)
											
											-- Two extra bytes for fragmented packets.
											:WriteByte(Packet.FragmentID)
											:WriteByte(Packet.FragmentCount)
											
										Packet.Sent = Time
										Packet.FragmentID = next(Packet.Fragment, Packet.FragmentID) or next(Packet.Fragment)
									end
								else
									-- Normal packets are sent completely at once
									
									local CompressionLength = #Packet.Compression
									if #Message + ChannelLength + CompressionLength + 8 < Connection.PacketMaxSize then
										-- Generate the packet header
										
										Message = Message
											:WriteByte(Packet:GetModifier())
											:WriteByte(ChannelLength)
											:WriteString(ChannelName)
											:WriteShort(ID)
											:WriteShort(Packet.TypeID)
											:WriteShort(CompressionLength)
											:WriteString(Packet.Compression)
											
										Packet.Sent = Time
									end
								end
							end
						end
					end
					
					for ID, Packet in pairs(Sending.Unreliable.Sequenced) do
						if type(ID) == "number" then
							if not Packet.Sent or Time - Packet.Sent >= Connection.PacketMaxDelay then
								-- Check that this packet wasn't sent too short ago

								local IsCompressed, IsFragmented = Packet:GenerateCompression()
								if IsFragmented then
									-- Fragmented packets are a bit different from normal packets
									
									local FragmentID = Packet.FragmentID
									local Fragment = Packet.Fragment[FragmentID]
									local FragmentLength = #Fragment

									if #Message + ChannelLength + FragmentLength + 10 < Connection.PacketMaxSize then
										-- Generate the packet header
										
										Message = Message
											:WriteByte(Packet:GetModifier())
											:WriteByte(ChannelLength)
											:WriteString(ChannelName)
											:WriteShort(ID)
											:WriteShort(Packet.TypeID)
											:WriteShort(FragmentLength)
											:WriteString(Fragment)
											
											-- Two extra bytes for fragmented packets.
											:WriteByte(Packet.FragmentID)
											:WriteByte(Packet.FragmentCount)
											
										Packet.Sent = Time
										Packet.FragmentID = next(Packet.Fragment, FragmentID)
										Packet.Fragment[FragmentID] = nil
										if Packet.FragmentID == nil then
											Packet.FragmentID = next(Packet.Fragment)
											if Packet.FragmentID == nil then
												Sending.Unreliable.Sequenced[ID] = nil
											end
										end
									end
								else
									-- Normal packets are sent completely at once
									
									local CompressionLength = #Packet.Compression
									if #Message + ChannelLength + CompressionLength + 8 < Connection.PacketMaxSize then
										-- Generate the packet header
										
										Message = Message
											:WriteByte(Packet:GetModifier())
											:WriteByte(ChannelLength)
											:WriteString(ChannelName)
											:WriteShort(ID)
											:WriteShort(Packet.TypeID)
											:WriteShort(CompressionLength)
											:WriteString(Packet.Compression)
											
										Packet.Sent = Time
										Sending.Unreliable.Sequenced[ID] = nil
									end
								end
							end
						end
					end
					
					for ID, Packet in pairs(Sending.Unreliable.Unsequenced) do
						
						if not Packet.Sent or Time - Packet.Sent >= Connection.PacketMaxDelay then
							-- Check that this packet wasn't sent too short ago
							
							local IsCompressed, IsFragmented = Packet:GenerateCompression()
							if IsFragmented then
								-- Fragmented packets are a bit different from normal packets
								
								local FragmentID = Packet.FragmentID
								local Fragment = Packet.Fragment[FragmentID]
								local FragmentLength = #Fragment

								if #Message + ChannelLength + FragmentLength + 10 < Connection.PacketMaxSize then
									-- Generate the packet header
									
									Message = Message
										:WriteByte(Packet:GetModifier())
										:WriteByte(ChannelLength)
										:WriteString(ChannelName)
										:WriteShort(ID)
										:WriteShort(Packet.TypeID)
										:WriteShort(FragmentLength)
										:WriteString(Fragment)
										
										-- Two extra bytes for fragmented packets.
										:WriteByte(Packet.FragmentID)
										:WriteByte(Packet.FragmentCount)
										
									Packet.Sent = Time
									Packet.FragmentID = next(Packet.Fragment, FragmentID)
									Packet.Fragment[FragmentID] = nil
									if Packet.FragmentID == nil then
										Packet.FragmentID = next(Packet.Fragment)
										if Packet.FragmentID == nil then
											Sending.Unreliable.Unsequenced[ID] = nil
										end
									end
								end
							else
								-- Normal packets are sent completely at once
								
								local CompressionLength = #Packet.Compression
								if #Message + ChannelLength + CompressionLength + 8 < Connection.PacketMaxSize then
									-- Generate the packet header
									
									Message = Message
										:WriteByte(Packet:GetModifier())
										:WriteByte(ChannelLength)
										:WriteString(ChannelName)
										:WriteShort(ID)
										:WriteShort(Packet.TypeID)
										:WriteShort(CompressionLength)
										:WriteString(Packet.Compression)
										
									Packet.Sent = Time
									Sending.Unreliable.Unsequenced[ID] = nil
								end
							end
						end
					end
					
				end
			end
		
			if #Message > 0 then
				local ByteModifier = 0
				
				if zlib then
					ByteModifier = ByteModifier + 2
					
					local Success, Memory = pcall(zlib.deflate, Message, {}, nil, "zlib", 9)
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
	
	local ProcessedPacket = self:ProcessNextPacket()
	repeat
		ProcessedPacket = self:ProcessNextPacket()
	until not ProcessedPacket
	
	local Time = socket.gettime() * 1000
	if Time - self.Sent >= 1000/self.PacketsPerSecond then
		self:Send()
		self.Sent = Time
	end
end
