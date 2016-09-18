local Path, PLAY2D, Connection = ...

local Packet = {}
local PacketMT = {__index = Packet}

function Connection.CreatePacket()
	
	local self = {
		
	}
	
	return setmetatable(self, PacketMT)
	
end

return Packet