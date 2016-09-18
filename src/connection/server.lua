local Path, PLAY2D, Connection = ...

local Server = {}
local ServerMT = {__index = Server}

function Connection.CreateServer(Port)
	
	local self = {
		
	}
	
	self.Protocol = {}
	self.Socket = {}
	
	return setmetatable(self, ServerMT)
	
end

return Server