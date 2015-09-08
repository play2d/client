local Path = ...

Core = {}

require(Path..".network")
require(Path..".map")

function Core.Load()
	Core.Network.Load()
	Core.Maps.Load()
	
	Core.Load = nil
end