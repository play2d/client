local Path, gui = ...

for _, File in pairs(love.filesystem.getDirectoryItems(Path)) do
	
	if love.filesystem.isDirectory(Path .. File) then
		
		local Coroutine = coroutine.create(love.filesystem.load(Path .. File.. "/init.lua"))
		
		coroutine.resume(Coroutine, gui)
		
	elseif File ~= "init.lua" then
		
		local Coroutine = coroutine.create(love.filesystem.load(Path .. File))
		
		coroutine.resume(Coroutine, gui)
		
	end
	
end

while next(gui.LoadQueue) do

	for i, Coroutine in pairs(gui.LoadQueue) do
		
		coroutine.resume(Coroutine)
		
		if coroutine.status(Coroutine) == "dead" then
			
			gui.LoadQueue[i] = nil
			
		end
		
	end
	
end

gui.LoadQueue = nil