function love.conf(t)
	t.identity = "play2d"					-- The name of the save directory (string)
	t.version = "0.9.2"						-- The LÖVE version this game was made for (string)
	t.console = true						-- Attach a console (boolean, Windows only)

	t.window.title = "Play2D"				-- The window title (string)
	t.window.icon = "game/icon.png"			-- Filepath to an image to use as the window's icon (string)
	t.window.width = 800					-- The window width (number)
	t.window.height = 600					-- The window height (number)
	t.window.borderless = false				-- Remove all border visuals from the window (boolean)
	t.window.resizable = false				-- Let the window be user-resizable (boolean)
	t.window.minwidth = 1					-- Minimum window width if the window is resizable (number)
	t.window.minheight = 1					-- Minimum window height if the window is resizable (number)
	t.window.fullscreen = false				-- Enable fullscreen (boolean)
	t.window.fullscreentype = "normal"		-- Standard fullscreen or desktop fullscreen mode (string)
	t.window.vsync = false					-- Enable vertical sync (boolean)
	t.window.fsaa = 0						-- The number of samples to use with multi-sampled antialiasing (number)
	t.window.display = 1					-- Index of the monitor to show the window in (number)
	t.window.highdpi = false				-- Enable high-dpi mode for the window on a Retina display (boolean)
	t.window.srgb = false					-- Enable sRGB gamma correction when drawing to the screen (boolean)
	t.window.x = nil						-- The x-coordinate of the window's position in the specified display (number)
	t.window.y = nil						-- The y-coordinate of the window's position in the specified display (number)

	t.modules.audio = true					-- Enable the audio module (boolean)
	t.modules.event = true					-- Enable the event module (boolean)
	t.modules.graphics = true				-- Enable the graphics module (boolean)
	t.modules.image = true					-- Enable the image module (boolean)
	t.modules.joystick = false				-- Enable the joystick module (boolean)
	t.modules.keyboard = true				-- Enable the keyboard module (boolean)
	t.modules.math = true					-- Enable the math module (boolean)
	t.modules.mouse = true					-- Enable the mouse module (boolean)
	t.modules.physics = true				-- Enable the physics module (boolean)
	t.modules.sound = true					-- Enable the sound module (boolean)
	t.modules.system = true					-- Enable the system module (boolean)
	t.modules.timer = true					-- Enable the timer module (boolean)
	t.modules.window = true					-- Enable the window module (boolean)
	t.modules.thread = true					-- Enable the thread module (boolean)
end

function love.run()
	love.math.setRandomSeed(os.time())
	for i = 1, 3 do love.math.random() end
 
	love.event.pump()
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	local tim = love.timer
	tim.step()
 
	local delta = 0
 
	local graphs = love.graphics
	local even = love.event

	-- Main loop time.
	repeat
		local startTime = tim.getTime()

		-- Process events.
		even.pump()
		for e,a,b,c,d in even.poll() do
			if e == "quit" then
				if not love.quit or not love.quit() then
					love.audio.stop()
					return
				end
			end
			love.handlers[e](a,b,c,d)
		end
 
		-- Update dt, as we'll be passing it to update
		tim.step()
		delta = tim.getDelta()
 
		-- Call update and draw
		love.update(delta)
 		
		if love.window and graphs and love.window.isCreated() then
			graphs.clear()
			graphs.origin()
			love.draw(delta)

			local r, g, b, a = graphs.getColor()

			graphs.setColor(200, 200, 200, 175)
			graphs.print("FPS: "..tostring(tim.getFPS()), 0, 0)
			
			graphs.setColor(r, g, b, a)
			graphs.present()
		end

		local endTime = tim.getTime()
		local deltaF = endTime - startTime

		if graphs.max then
			local maxDelta = 1 / graphs.max
			local sleep = maxDelta - deltaF

			if sleep >= 0.001 then
				tim.sleep(sleep)
			end
		else
			tim.sleep(0.001)
		end
	until false
end

local ffi = require("ffi")
ffi.cdef[[ int PHYSFS_mount(const char *newDir, const char *mountPoint, int appendToPath); ]]; 
ffi.cdef[[ int PHYSFS_setWriteDir(const char *newDir); ]]
local liblove = ffi.os == "Windows" and ffi.load("love") or ffi.C
local docsdir = love.filesystem.getSourceBaseDirectory()
liblove.PHYSFS_setWriteDir(docsdir)
liblove.PHYSFS_mount(docsdir, nil, 0)