commands = {}
commands.list = {}

function parse(command)
	if type(command) == "string" then
		console.run(command, commands.list)
	end
end

function commands.load()
	local Files = love.filesystem.getDirectoryItems("sys/commands")
	for _, File in pairs(Files) do
		local Command = string.match(File, "(%a+)%p(%a+)")
		local Path = "sys/commands/"..File
		if love.filesystem.isFile(Path) then
			local Okay, f = pcall(love.filesystem.load, Path)
			if f then
				commands.list[string.lower(Command)] = f
			else
				print("Lua Error [Command: "..Command.."]: "..f)
			end
		end
	end
	commands.load = nil
end

hook.Add("load", commands.load)
