local Path = ...

Core = {}

require(Path..".network")
require(Path..".map")
require(Path..".microphone")

function Core.Load()
	Core.Network.Load()
	Core.Maps.Load()
	Core.Microphone.Load()
	
	Core.Load = nil
end

function Core.Update(dt)
	--Core.Microphone.Update(dt)
end