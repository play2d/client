local PLAY2D = {}
local Path = (...):gsub("%p", "/")

function PLAY2D.Require(Name, ...)
	
	if love.filesystem.isDirectory(Name) then
		
		return assert( love.filesystem.load(Name.."/init.lua") ) (Name, PLAY2D, ...)
		
	end
	
	return assert( love.filesystem.load(Name..".lua") ) (Name, PLAY2D, ...)
	
end

PLAY2D.Socket = require "socket"
PLAY2D.FFI = require "ffi"
PLAY2D.FFI.cdef[[ int PHYSFS_setWriteDir(const char *newDir); ]];
PLAY2D.FFI.cdef[[ int PHYSFS_removeFromSearchPath(const char *newDir); ]];
PLAY2D.FFI.cdef[[ int PHYSFS_mount(const char *newDir, const char *mountPoint, int appendToPath); ]]; 

PLAY2D.C = PLAY2D.FFI.os == "Windows" and PLAY2D.FFI.load("love") or PLAY2D.FFI.C

PLAY2D.Utility = PLAY2D.Require(Path.."/utility")
PLAY2D.Connection = PLAY2D.Require(Path.."/connection")
PLAY2D.Resources = PLAY2D.Require(Path.."/resources")
PLAY2D.Filesystem = PLAY2D.Require(Path.."/filesystem")
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
	
	-- It's necessary to load the filesystem lib for proper file accessing and writting (thus, configuration system needs it)
	PLAY2D.Filesystem.load()

	-- If we don't load the commands, we can't load the configuration
	PLAY2D.Commands.load()
	PLAY2D.Configuration.load()
	
	-- It's necessary to load the language translations first before loading the interface
	PLAY2D.Language.load()

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
