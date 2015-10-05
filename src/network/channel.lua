local TChannel = {}
local TChannelMetatable = {__index = TChannel}
TChannel.Type = "Channel"

function Network.CreateChannel()
	local Channel = {
		-- I decided to put each one in it's list because we can't synchronize reliable sequenced and unreliable sequenced packets in a same list.
		Received = {
			Reliable = {Sequenced = {}, Unsequenced = {}},
			Unreliable = {Sequenced = {}, Unsequenced = {}},
		},
		Sending = {
			Reliable = {Sequenced = {}, Unsequenced = {}},
			Unreliable = {Sequenced = {}, Unsequenced = {}},
		},
	}
	return setmetatable(Channel, TChannelMetatable)
end

function TChannel:GetNextReceivedPacket()
	local RS = self.Received.Reliable.Sequenced
	local RU = self.Received.Reliable.Unsequenced
	local US = self.Received.Unreliable.Sequenced
	local UU = self.Received.Unreliable.Unsequenced
	
	if RS.Current then
		-- Reliable sequenced

		if not RS.Current.Processed then
			-- The first packet being received will instantly be assigned to RS.Current so we added this to check that it exists and it wasn't processed
			
			if RS.Current.Complete then
				-- But it can't be processed if it's incomplete
				
				RS.Current.Processed = true
				return RS.Current
			end
		end
		
		for ID, Packet in pairs(RS) do
			if Packet.Complete and not Packet.Processed then
				-- We must never process packets that are still going to be fragmented

				if Packet:IsRightAfter(RS.Current) then
					-- New unprocessed current packet, process it
					if RS.Current.Reply or RS.Current.Confirm then
						break
					end
					
					RS[RS.Current.ID] = nil
					RS.Current = Packet
						
					Packet.Processed = true
					return Packet
				end
			end
		end
	end
	
	if RU.Current then
		-- Reliable Unsequenced
		if not RU.Current.Processed then
			
			if RU.Current.Complete then
				
				RU.Current.Processed = true
				return RU.Current
			end
		end
		
		for ID, Packet in pairs(RU) do
			if Packet.Complete and not Packet.Processed then
				-- Reliable Unsequenced packets are fragmented too, so check that it's complete
				
				if Packet:IsRightAfter(RU.Current) then
					if RU.Current.Reply or RU.Current.Confirm then
						break
					end
					RU[RU.Current.ID] = nil
					RU.Current = Packet
				end
				
				Packet.Processed = true
				return Packet
			end
		end
	end
	
	if US.Current then
		-- Unreliable Sequenced
		
		if not US.Current.Processed then
			-- The first packet on the channel is always the first current packet, but it is never instantly processed so return it
			
			if US.Current.Complete then
				-- But it can't be processed if it's incomplete
				
				US[US.Current.ID] = nil
				US.Current.Processed = true
				return US.Current
			end
		end
		
		for ID, Packet in pairs(US) do
			if Packet.Complete and not Packet.Processed then
				-- This is rarely going to happen but the Lua script might be able to send a complete unreliable sequenced packet somehow
				US[ID] = nil
				
				if Packet:IsAfter(US.Current) then
					-- Since it's unreliable, any packet that goes after this one must be the next current packet
					US.Current = Packet
					
					-- However we don't want the previous code to return it twice
					Packet.Processed = true
					return US.Current
				end
			end
		end
	end
	
	for ID, Packet in pairs(UU) do
		-- Unreliable Unsequenced, always send what you find
		if Packet.Complete and not Packet.Processed then
			-- As long as it's complete, rarely going to happen too
			
			UU[ID] = nil
			return Packet
		end
	end
end

function TChannel:RemovePacket(ID, Reliable, Sequenced)
	local Sending = self.Sending
	if Reliable then
		if Sequenced then
			if Sending.Reliable.Sequenced[ID] then
				Sending.Reliable.Sequenced[ID] = nil
				return true
			end
		else
			if Sending.Reliable.Unsequenced[ID] then
				Sending.Reliable.Unsequenced[ID] = nil
				return true
			end
		end
	elseif Sequenced then
		if Sending.Unreliable.Sequenced[ID] then
			Sending.Unreliable.Sequenced[ID] = nil
			return true
		end
	elseif Sending.Unreliable.Unsequenced[ID] then
		Sending.Unreliable.Unsequenced[ID] = nil
		return true
	end
end

function TChannel:GetPacket(ID, Reliable, Sequenced)
	local Received = self.Received
	if Reliable then
		if Sequenced then
			return Received.Reliable.Sequenced[ID]
		end
		return Received.Reliable.Unsequenced[ID]
	elseif Sequenced then
		return Received.Unreliable.Sequenced[ID]
	end
	return Received.Unreliable.Unsequenced[ID]
end

function TChannel:GetNewPacket(ID, TypeID, First, Reliable, Sequenced)
	local Received = self.Received
	if Reliable then
		if Sequenced then
			local Packet = Received.Reliable.Sequenced[ID]
			if not Packet then
				Packet = Network.CreatePacket(TypeID)
				Packet.ID = ID
				Packet.Reliable = true
				Packet.Sequenced = true
				Received.Reliable.Sequenced[ID] = Packet
				
				if First then
					if not Received.Reliable.Sequenced.Current then
						Received.Reliable.Sequenced.Current = Packet
					end
				end
			end
			return Packet
		end
		local Packet = Received.Reliable.Unsequenced[ID]
		if not Packet then
			Packet = Network.CreatePacket(TypeID)
			Packet.ID = ID
			Packet.Reliable = true
			Received.Reliable.Unsequenced[ID] = Packet
			if First then
				if not Received.Reliable.Unsequenced.Current then
					Received.Reliable.Unsequenced.Current = Packet
				end
			end
		end
		return Packet
	elseif Sequenced then
		local Packet = Received.Unreliable.Sequenced[ID]
		if not Packet then
			Packet = Network.CreatePacket(TypeID)
			Packet.ID = ID
			Packet.Sequenced = true
			Received.Unreliable.Sequenced[ID] = Packet

			-- No first check here, what we receive will always be the first because it's unreliable
			if not Received.Unreliable.Sequenced.Current then
				Received.Unreliable.Sequenced.Current = Packet
			end
		end
		return Packet
	end
	
	local Packet = Received.Unreliable.Unsequenced[ID]
	if not Packet then
		Packet = Network.CreatePacket(TypeID)
		Packet.ID = ID
		Received.Unreliable.Unsequenced[ID] = Packet
	end
	return Packet
end

function TChannel:GetCreatedPacket(ID, Reliable, Sequenced)
	local Sending = self.Sending
	if Reliable then
		if Sequenced then
			return Sending.Reliable.Sequenced[ID]
		end
		return Sending.Reliable.Unsequenced[ID]
	elseif Sequenced then
		return Sending.Unreliable.Sequenced[ID]
	end
	return Sending.Unreliable.Unsequenced[ID]
end

function TChannel:CreateNewPacket(TypeID, Reliable, Sequenced)
	local Sending = self.Sending
	local Packet = Network.CreatePacket(TypeID)
	if Reliable then
		Packet.Reliable = true

		if Sequenced then
			Packet.Sequenced = true
			
			if Sending.Reliable.Sequenced.Current == nil then
				Sending.Reliable.Sequenced.Current = Packet
				Packet.ID = 1
				Packet.First = true
			else
				Packet.ID = (Sending.Reliable.Sequenced.Current.ID % 65535) + 1
				Sending.Reliable.Sequenced.Current = Packet
			end
			
			Sending.Reliable.Sequenced[Packet.ID] = Packet
			return Packet
		end

		if Sending.Reliable.Unsequenced.Current == nil then
			Sending.Reliable.Unsequenced.Current = Packet
			Packet.ID = 1
			Packet.First = true
		else
			Packet.ID = (Sending.Reliable.Unsequenced.Current.ID % 65535) + 1
			Sending.Reliable.Unsequenced.Current = Packet
		end
		
		Sending.Reliable.Unsequenced[Packet.ID] = Packet
		return Packet
	elseif Sequenced then
		Packet.Sequenced = true
		
		if Sending.Unreliable.Sequenced.Current == nil then
			Sending.Unreliable.Sequenced.Current = Packet
			Packet.ID = 1
			Packet.First = true
		else
			Packet.ID = (Sending.Unreliable.Sequenced.Current.ID % 65535) + 1
			Sending.Unreliable.Sequenced.Current = Packet
		end
		
		Sending.Unreliable.Sequenced[Packet.ID] = Packet
		return Packet
	end

	if Sending.Unreliable.Unsequenced.Current == nil then
		Sending.Unreliable.Unsequenced.Current = Packet
		Packet.ID = 1
		Packet.First = true
	else
		Packet.ID = (Sending.Unreliable.Unsequenced.Current.ID % 65535) + 1
		Sending.Unreliable.Unsequenced.Current = Packet
	end

	Sending.Unreliable.Unsequenced[Packet.ID] = Packet
	return Packet
end