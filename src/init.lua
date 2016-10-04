local PLAY2D = {}
local Path = (...):gsub("%p", "/")

function PLAY2D.Require(Name, ...)
	
	if love.filesystem.isDirectory(Name) then
		
		return assert( love.filesystem.load(Name.."/init.lua") ) (Name, PLAY2D, ...)
		
	end
	
	return assert( love.filesystem.load(Name..".lua") ) (Name, PLAY2D, ...)
	
end

local function requireAttempt(what)
	
	local Ok, Library = pcall(require, what)
	
	if Ok then
		
		return Library
		
	end
	
end

PLAY2D.OS = love.system.getOS()
PLAY2D.FFI = require "ffi"

if PLAY2D.OS == "Windows" then
	
	package.cpath = package.cpath..";./bin_"..PLAY2D.FFI.arch.."/?.dll"
	
elseif PLAY2D.OS == "OS X" then
	
	package.cpath = package.cpath..";./bin_"..PLAY2D.FFI.arch.."/?.dylib"
	
else
	
	package.cpath = package.cpath..";./bin_"..PLAY2D.FFI.arch.."/?.so"
	
end

PLAY2D.SSL = requireAttempt "ssl"
PLAY2D.HTTPS = requireAttempt "ssl.https"
PLAY2D.HTTP = require "socket.http"

PLAY2D.Socket = require "socket"
PLAY2D.UTF8 = require "utf8"
PLAY2D.JSON = require((...)..".json")
PLAY2D.FFI.cdef[[ int PHYSFS_setWriteDir(const char *newDir); ]]
PLAY2D.FFI.cdef[[ int PHYSFS_removeFromSearchPath(const char *newDir); ]]
PLAY2D.FFI.cdef[[ int PHYSFS_mount(const char *newDir, const char *mountPoint, int appendToPath); ]]
PLAY2D.FFI.cdef[[ int PHYSFS_addToSearchPath (const char *newDir, int appendToPath); ]]

PLAY2D.Mobile = PLAY2D.OS == "Android" or PLAY2D.OS == "iOS"
PLAY2D.C = PLAY2D.OS == "Windows" and PLAY2D.FFI.load("love") or PLAY2D.FFI.C

if not PLAY2D.Mobile then
	
	PLAY2D.C.PHYSFS_addToSearchPath(love.filesystem.getSourceBaseDirectory(), 0)
	PLAY2D.C.PHYSFS_setWriteDir(love.filesystem.getWorkingDirectory())
	
end

PLAY2D.Constants = PLAY2D.Require(Path.."/constants")
PLAY2D.Utility = PLAY2D.Require(Path.."/utility")
PLAY2D.Connection = PLAY2D.Require(Path.."/connection")
PLAY2D.Resources = PLAY2D.Require(Path.."/resources")
PLAY2D.Terminal = PLAY2D.Require(Path.."/terminal")
PLAY2D.Commands = PLAY2D.Require(Path.."/commands")
PLAY2D.Configuration = PLAY2D.Require(Path.."/configuration")
PLAY2D.Language = PLAY2D.Require(Path.."/language")
PLAY2D.gui = PLAY2D.Require(Path.."/gui")
PLAY2D.Interface = PLAY2D.Require(Path.."/interface")
PLAY2D.Master = PLAY2D.Require(Path.."/masterserver")

function PLAY2D.Print(...)
	
	PLAY2D.Interface.Console.Print(...)
	
end

function PLAY2D.load()
	-- Cap the framerate
	-- love.graphics.maxFramerate = 60

	-- If we don't load the commands, we can't load the configuration
	PLAY2D.Commands.load()
	PLAY2D.Configuration.load()
	
	-- It's necessary to load the language translations first before loading the interface
	PLAY2D.Language.load()
	
	-- Loading the login is priority for the interface
	PLAY2D.Master.LoadLogin()

	-- The interface requires the gui functions
	PLAY2D.gui.load()
	PLAY2D.Interface.load()
	
	-- The master server connection
	PLAY2D.Master.load()

	-- Example and Demonstration of the Assets loading and queuing system
	FiveSevenQueue = PLAY2D.Assets.CreateQueue("assets", "Game content")
	FiveSevenQueue:AddToQueue(
		{"image", "gfx/weapons/Five Seven/silenced.png"},
		{"image", "gfx/weapons/Five Seven/drop.png"},
		{"sound", "sfx/weapons/Five Seven/shot.wav"},
		{"sound", "sfx/weapons/Five Seven/silenced.wav"}
	)
	
end

function PLAY2D.update(Delta)
	
	if not FiveSevenQueue:IsDone() then
		
		FiveSevenQueue:Update(Delta)
		
	end
	
	PLAY2D.gui.update(Delta)
	PLAY2D.Master.update()
	
end

function PLAY2D.draw()
	
	if not FiveSevenQueue:IsDone() then
		
		FiveSevenQueue:Draw()
		
	else
		
		PLAY2D.gui.draw()
		
	end
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
