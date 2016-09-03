local Command = ...

Command.Category = "Local"

local Dir = love.filesystem.getWorkingDirectory():sub(1,-8)

function Command.Execute(Terminal, String)
	local newDir = String and tostring(String)
	
	if newDir then
		local Ok, ErrorOrValue = pcall(Configuration.SavePointer, String)

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
	print(String)
	if String then
		local newDir = String.."/play2d"
		local Ok, ErrorOrValue = pcall(Filesystem.changeWorkingDir, newDir)

		if Ok then
			Dir = newDir
			return true
		else
			-- Err
			return false
		end
	end
end