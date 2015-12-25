game = {
	VERSION = "0.0.0.1a",
	CODENAME = "LuaJIT Rox",
	DATE = "13/07/2015",
}
CLIENT = true

require("src.hook")
Hook.Create("draw")
Hook.Create("update")

require("src.lib")
require("src.gui")
require("src.constants")
require("src.commands")
require("src.config")
require("src.language")
require("src.core")
require("src.binds")
require("src.interface")
require("src.cache")
require("src.classes")

function love.draw(dt)
	Hook.Call("draw", dt)

	-- Interface is always at top of everything
	Interface.Render(dt)
end

function love.update(dt)
	Interface.Update(dt)
	Core.Update(dt)

	Hook.Call("update", dt)
end

function love.load(arg)
	Commands.Load()
	Config.Load()
	Lang.Load()
	Interface.Load()
	Core.Load()
	Cache.Load()
end