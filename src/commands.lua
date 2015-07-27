commands = {}
commands.list = {}
commands.temp = {}

function parse(command, source)
	if type(command) == "string" then
		console.run(command, commands.list, source or {source = "game"})
	end
end

function commands.cleanTemp()
	commands.temp = {}
	setmetatable(commands.list, {__index = commands.temp})
end

function commands.load()
	local Files = love.filesystem.getDirectoryItems("sys/commands")
	for _, File in pairs(Files) do
		if File:sub(-4) == ".lua" then
			local Command = string.match(File, "([%a|%_]+)%p(%a+)")
			local Path = "sys/commands/"..File
			if love.filesystem.isFile(Path) then
				local Function, Error = loadfile(Path)
				if Function then
					commands.list[string.lower(Command)] = Function
				else
					print("Lua Error [Command: "..Command.."]: "..Error)
				end
			end
		end
	end
	commands.load = nil
end

Hook.Add("load", commands.load)
