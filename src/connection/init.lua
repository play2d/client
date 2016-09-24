local Path, PLAY2D = ...

local Connection = {}

Connection.Packet = PLAY2D.Require(Path.."/packet", Connection)
Connection.Client = PLAY2D.Require(Path.."/client", Connection)
Connection.Server = PLAY2D.Require(Path.."/server", Connection)

return Connection