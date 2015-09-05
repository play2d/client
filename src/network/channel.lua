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
		
		if not RS.Current.Processed and RS.Current.Complete then
			-- The first packet being received will instantly be assigned to RS.Current so we added this to check that it exists and it wasn't processed
			RS.Current.Processed = true
			return RS.Current
		end
		
		for ID, Packet in pairs(RS) do
			if Packet.Complete then
				-- We must never process packets that are still going to be fragmented
				
				if Packet.Processed then
					-- This case is very rarely going to happen, but I'll add it just in case?
					RS[ID] = nil
				else
					-- Unprocessed packets will be met here
						if Packet:IsRightAfter(RS.Current) then
						-- Current packet is already processed so it's just being an annoying memory there, delete it
						RS[RS.Current.ID] = nil
						
						-- New unprocessed current packet, process it
						RS.Current = Packet
						Packet.Processed = true
						return Packet
					end
				end
			end
		end
	end
	
	if RU.Current then
		-- Reliable Unsequenced
		for ID, Packet in pairs(RU) do
			if Packet.Complete then
				-- Reliable Unsequenced packets are fragmented too, so check that it's complete
				
				if not RU.Current or Packet:IsAfter(RU.Current) then
					-- Reliable, but unsequenced, which means there could be or not a current packet
					
					if Packet:IsRightAfter(RU.Current) then
						-- It being after the current packet we processed means we can delete the current packet and make this one the new current
						RU[RU.Current.ID] = nil
						RU.Current = Packet
					end
					
					if not Packet.Processed then
						-- In case that the packet that goes after the current packet hasn't been received
						Packet.Processed = true
						return Packet
					end
				end
			end
		end
	end
	
	if US.Current then
		-- Unreliable Sequenced
		
		if not US.Current.Processed then
			-- The first packet on the channel is always the first current packet, but it is never instantly processed so return it
			US.Current.Processed = true
			return US.Current
		end
		
		for ID, Packet in pairs(US) do
			if Packet.Complete then
				-- This is rarely going to happen but the Lua script might be able to send a complete unreliable sequenced packet somehow
				
				if Packet:IsAfter(US.Current) then
					-- Since it's unreliable, any packet that goes after this one must be the next current packet
					US[US.Current.ID] = nil
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
		if Packet.Complete then
			-- As long as it's complete
			
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

function TChannel:GetPacket(ID, First, Reliable, Sequenced)
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