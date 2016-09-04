local Command = ...

Command.Category = "Local"

local Dir = love.filesystem.getSaveDirectory():sub(1,-8)

function Command:Execute(Terminal, String)
	local newDir = String
	
	if newDir then
		local Ok, ErrorOrValue = pcall(PLAY2D.Filesystem.SaveGameDir, String)

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

function Command:Set(String)
	if String then
		local newDir = (String:sub(-1) ~= "/" and String) or String:sub(1, -1)
		if newDir:sub(-6) ~= "play2d" then
			newDir = newDir.."/play2d"
		end

		local Ok, ErrorOrValue = pcall(PLAY2D.Filesystem.ChangeWorkingDir, PLAY2D.Commands.List["gameDir"]:GetString(), newDir)

		if Ok then
			Dir = newDir
			return true
		else
			-- Err
			return false
		end
	end
end