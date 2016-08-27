local PLAY2D = {}
local Path = ...

function PLAY2D.Require(File)
	return assert(love.filesystem.load(Path.."/"..File))(PLAY2D)
end

PLAY2D.gui = require(Path..".gui")

PLAY2D.terminal = PLAY2D.Require("terminal.lua")

function PLAY2D.load()
	PLAY2D.gui.load()
end

function PLAY2D.update(dt)
	PLAY2D.gui.update(dt)
end

function PLAY2D.draw()
	PLAY2D.gui.draw()
end

function PLAY2D.mousepressed(...)
	PLAY2D.gui.mousepressed(...)
end

function PLAY2D.mousereleased(...)
	PLAY2D.gui.mousereleased(...)
end

function PLAY2D.mousemoved(...)
	PLAY2D.gui.mousemoved(...)
end

function PLAY2D.wheelmoved(...)
	PLAY2D.gui.wheelmoved(...)
end

function PLAY2D.keypressed(...)
	PLAY2D.gui.keypressed(...)
end

function PLAY2D.textinput(...)
	PLAY2D.gui.textinput(...)
end

return PLAY2D