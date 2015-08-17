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
	if self.Open then
		local RS = self.Received.Reliable.Sequenced
		local RU = self.Received.Reliable.Unsequenced
		local US = self.Received.Unreliable.Sequenced
		local UU = self.Received.Unreliable.Unsequenced
		if RS.Current then
			if not RS.Current.Processed then
				RS.Current.Processed = true
				return RS.Current
			end
			for ID, Packet in pairs(RS) do
				if type(Packet) == "table" then
					if Packet:IsRightAfter(Packet) then
						RS[RS.Current.ID] = nil
						RS.Current = Packet
						Packet.Processed = true
						return Packet
					end
				end
			end
		end
		
		if RU.Current then
			if not RU.Current.Processed then
				RU.Current.Processed = true
				return RU.Current
			end
			for ID, Packet in pairs(RU) do
				if type(Packet) == "table" then
					if Packet:IsAfter(RU.Current) then
						if Packet:IsRightAfter(RU.Current) then
							RU[RU.Current.ID] = nil
							RU.Current = Packet
						end
						if not Packet.Processed then
							Packet.Processed = true
							return Packet
						end
					end
				end
			end
		end
		
		if US.Current then
			if not US.Current.Processed then
				US.Current.Processed = true
				return US.Current
			end
			for ID, Packet in pairs(US) do
				if type(Packet) == "table" then
					if Packet:IsAfter(US.Current) then
						US[US.Current.ID] = nil
						US.Current = Packet
						Packet.Processed = true
						return US.Current
					end
				end
			end
		end
		
		for ID, Packet in pairs(UU) do
			UU[ID] = nil
			return Packet
		end
	end
end

function TChannel:GetPacket(ID, First, Reliable, Sequenced)
	if Reliable then
		if Sequenced then
			local Packet = self.Received.Reliable.Sequenced[ID]
			if not Packet then
				Packet = Network.CreatePacket()
				Packet.ID = ID
				Packet.Reliable = true
				Packet.Sequenced = true
				self.Received.Reliable.Sequenced[ID] = Packet
				if First and not self.Received.Reliable.Sequenced.Current then
					self.Received.Reliable.Sequenced.Current = Packet
				end
			end
			return Packet
		end
		local Packet = self.Received.Reliable.Unsequenced[ID]
		if not Packet then
			Packet = Network.CreatePacket()
			Packet.ID = ID
			Packet.Reliable = true
			self.Received.Reliable.Unsequenced[ID] = Packet
			if First and not self.Received.Reliable.Unsequenced.Current then
				self.Received.Reliable.Unsequenced.Current = Packet
			end
		end
		return Packet
	elseif Sequenced then
		local Packet = self.Received.Unreliable.Sequenced[ID]
		if not Packet then
			Packet = Network.CreatePacket()
			Packet.ID = ID
			Packet.Sequenced = true
			self.Received.Unreliable.Sequenced[ID] = Packet
			if First and not self.Received.Unreliable.Sequenced.Current then
				self.Received.Unreliable.Sequenced.Current = Packet
			end
		end
		return Packet
	end
	local Packet = self.Received.Unreliable.Unsequenced[ID]
	if not Packet then
		Packet = Network.CreatePacket()
		Packet.ID = ID
		self.Received.Unreliable.Unsequenced[ID] = Packet
	end
	return Packet
end