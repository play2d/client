commands = {}
commands.list = {}
commands.temp = {}

function parse(command)
	if type(command) == "string" then
		console.run(command, commands.list)
	end
end

function commands.cleanTemp()
	commands.temp = {}
	setmetatable(commands.list, {__index = commands.temp})
end

function commands.load()
	local Files = love.filesystem.getDirectoryItems("sys/commands")
	for _, File in pairs(Files) do
		local Command = string.match(File, "(%a+)%p(%a+)")
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
	commands.load = nil
end

Hook.Add("load", commands.load)
