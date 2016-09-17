function love.conf(t)
	t.identity = "play2d"					-- The name of the save directory (string)
	t.version = "0.10.1"				-- The LÃ–VE version this game was made for (string)
	t.console = true				   -- Attach a console (boolean, Windows only)
	t.accelerometerjoystick = false	  -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
	t.gammacorrect = false			  -- Enable gamma-correct rendering, when supported by the system (boolean)
 
	t.window.title = "Play2D"		 -- The window title (string)
	t.window.icon = "src/icon.png"				 -- Filepath to an image to use as the window's icon (string)
	t.window.width = 800				-- The window width (number)
	t.window.height = 600			   -- The window height (number)
	t.window.borderless = false		 -- Remove all border visuals from the window (boolean)
	t.window.resizable = false		  -- Let the window be user-resizable (boolean)
	t.window.minwidth = 1			   -- Minimum window width if the window is resizable (number)
	t.window.minheight = 1			  -- Minimum window height if the window is resizable (number)
	t.window.fullscreen = false		 -- Enable fullscreen (boolean)
	t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
	t.window.vsync = false			   -- Enable vertical sync (boolean)
	t.window.msaa = 0				   -- The number of samples to use with multi-sampled antialiasing (number)
	t.window.display = 1				-- Index of the monitor to show the window in (number)
	t.window.highdpi = false			-- Enable high-dpi mode for the window on a Retina display (boolean)
	t.window.x = nil					-- The x-coordinate of the window's position in the specified display (number)
	t.window.y = nil					-- The y-coordinate of the window's position in the specified display (number)
 
	t.modules.audio = true			  -- Enable the audio module (boolean)
	t.modules.event = true			  -- Enable the event module (boolean)
	t.modules.graphics = true		   -- Enable the graphics module (boolean)
	t.modules.image = true			  -- Enable the image module (boolean)
	t.modules.joystick = true		   -- Enable the joystick module (boolean)
	t.modules.keyboard = true		   -- Enable the keyboard module (boolean)
	t.modules.math = true			   -- Enable the math module (boolean)
	t.modules.mouse = true			  -- Enable the mouse module (boolean)
	t.modules.physics = true			-- Enable the physics module (boolean)
	t.modules.sound = true			  -- Enable the sound module (boolean)
	t.modules.system = true			 -- Enable the system module (boolean)
	t.modules.timer = true			  -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
	t.modules.touch = false			  -- Enable the touch module (boolean)
	t.modules.video = false			  -- Enable the video module (boolean)
	t.modules.window = true			 -- Enable the window module (boolean)
	t.modules.thread = true			 -- Enable the thread module (boolean)
end

function love.run()
	love.math.setRandomSeed(os.time())

	love.load(arg)
	
	local tim = love.timer
	local graphs = love.graphics
	local even = love.event
	
	local delta = 0
	
	local defaultFont = graphs.newFont(12)
	
	tim.step()
	
	-- Main loop time.
	while true do
		local startTime = tim.getTime()
		
		-- Process events.
		even.pump()	
		for name, a, b, c, d, e, f in even.poll() do
			if name == "quit" then
				if not love.quit or not love.quit() then
					return love.audio.stop()
				end
			end
			
			love.handlers[name](a, b, c, d, e, f)
		end
 
		-- Update dt, as we'll be passing it to update
		tim.step()
		delta = tim.getDelta()
 
		-- Call update and draw
		love.update(delta)
 
		if graphs and graphs.isActive() then
			graphs.clear(graphs.getBackgroundColor())
			graphs.origin()
			love.draw()
			
			local r, g, b, a = graphs.getColor()
			local font = graphs.getFont()

			graphs.setColor(200, 200, 200, 175)
			graphs.setFont(defaultFont)
			graphs.print("FPS: "..math.floor(1 / delta + 0.5), 0, 0)
			
			graphs.setColor(r, g, b, a)
			graphs.setFont(font)
			graphs.present()
		end
		
		local endTime = tim.getTime()
		local deltaF = endTime - startTime

		if graphs.maxFramerate then
			local maxDelta = 1 / graphs.maxFramerate
			local sleep = maxDelta - deltaF

			if sleep >= 0.001 then
				tim.sleep(sleep)
			end
		else
			tim.sleep(0.001)
		end
	end

end
