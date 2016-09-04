local Command = ...

Command.Category = "Local"

local Dir = love.filesystem.getSaveDirectory():sub(1,-8)

function Command:Execute(Terminal, String)
	local newDir = String
	
	if newDir then
		local Ok, ErrorOrValue = pcall(self:Save())

		if Ok then
			-- Prompt user to restart game
		else
			-- Do not know how you want to deal with errors yet so will put an Err comment at each one of these
		end
	else
		-- Err
	end
end

function Command:GetString()
	return Dir
end

function Command:Set(String, Formatted)
	if String then

		local newDir = (String:sub(-1) ~= "/" and String) or String:sub(1, -1)
		newDir = (newDir:sub(-6) ~= "play2d" and not Formatted and newDir.."/play2d") or newDir

		local Ok, ErrorOrValue = pcall(PLAY2D.Filesystem.GotoDir, newDir)

		if Ok then
			PLAY2D.Filesystem.ExitDir(self:GetString())
			Dir = newDir
			return true

		else
			-- Err
			return false

		end

	end

end

function Command:Save(Dir)
	local Dir = Dir or Self:GetString()
	local File = love.filesystem.newFile("sys/"..socket.dns.gethostname()..".cfg", "w")

	if File then
		
		File:write(Dir)
		File:close()
		
	else
		
		-- Err
		
	end
end