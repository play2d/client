local Path = ...

game.core = {}

require(Path..".map")
require(Path..".localhost")

function game.core.load()
	game.core.LoadLocalHost()
	game.core.InitializeMapFormats()
end