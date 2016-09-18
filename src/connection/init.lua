local Path, PLAY2D = ...

local Connection = {}

Connection.Packet = PLAY2D.Require2(Path.."/packet", Connection)
Connection.Server = PLAY2D.Require2(Path.."/server", Connection)

return Connection