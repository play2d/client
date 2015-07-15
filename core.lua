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
	while true do
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
			love.draw()
			graphs.present()
		end

		tim.sleep(0.001)
	end
end