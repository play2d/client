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

for _, Coroutine in pairs(gui.LoadQueue) do
	
	coroutine.resume(Coroutine)
	
end

gui.LoadQueue = nil