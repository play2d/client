local Path = ...

Core = {}
Core.Connect = {}
Core.State = {}
Core.LuaState = {}
Core.Network = {}
Core.Transfer = {}
Core.Maps = {}
Core.Bans = {}

-- Network hooks
Hook.Create("ENetConnect")
Hook.Create("ENetDisconnect")

require(Path..".state")
require(Path..".luastate")
require(Path..".network")
require(Path..".transfer")
require(Path..".map")
require(Path..".microphone")

function Core.Load()
	Core.Network.Load()
	Core.Microphone.Load()
	Core.Transfer.Load()
	
	Core.Load = nil
end

function Core.Update(dt)
	Core.Network.Update(dt)
	Core.State.Update(dt)
end