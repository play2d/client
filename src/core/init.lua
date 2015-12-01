local Path = ...

Core = {}

require(Path..".transfer")
require(Path..".network")
require(Path..".map")
require(Path..".microphone")
require(Path..".state")

function Core.Load()
	Core.Network.Load()
	Core.Microphone.Load()
	Core.Transfer.Load()
	
	Core.Load = nil
end

function Core.Update(dt)
	Core.Network.Update(dt)
end