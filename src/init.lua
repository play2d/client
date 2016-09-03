local PLAY2D = {}
local Path = ...

function PLAY2D.Require(Name, ...)
	if love.filesystem.isDirectory(Path.."/"..Name) then
		return assert(love.filesystem.load(Path.."/"..Name.."/init.lua"))(Path:gsub("/", ".").."."..Name, PLAY2D, ...)
	end
	return assert(love.filesystem.load(Path.."/"..Name..".lua"))(Path:gsub("/", ".").."."..Name, PLAY2D, ...)
end

PLAY2D.Socket = require "socket"
PLAY2D.FFI = require "ffi"
PLAY2D.FFI.cdef [[
void PHYSFS_addToSearchPath(const char *newDir, int appendToPath);
int PHYSFS_setWriteDir ( const char *  newDir  );
]]
PLAY2D.C = PLAY2D.FFI.os == "Windows" and PLAY2D.FFI.load("love") or PLAY2D.FFI.C

PLAY2D.filesystem = PLAY2D.Require("filesystem")
PLAY2D.Terminal = PLAY2D.Require("terminal")
PLAY2D.Commands = PLAY2D.Require("commands")
PLAY2D.Configuration = PLAY2D.Require("configuration")
PLAY2D.Language = PLAY2D.Require("language")
PLAY2D.gui = PLAY2D.Require("gui")
PLAY2D.Interface = PLAY2D.Require("interface")

function PLAY2D.load()
	
	-- If we don't load the commands, we can't load the configuration
	PLAY2D.Commands.load()
	PLAY2D.Configuration.load()
	
	-- It's necessary to load the language translations first before loading the interface
	PLAY2D.Language.load()
	
	-- The interface requires the gui functions
	PLAY2D.gui.load()
	PLAY2D.Interface.load()
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