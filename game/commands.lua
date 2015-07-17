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
	for File in lfs.dir("sys/commands") do -- CODE CRASHES HERE
		if File ~= "." and File ~= ".." then
			local Command = string.match(File, "(%a+)%p(%a+)")
			local Path = "sys/commands/"..File
			if lfs.attributes(Path, "mode") == "file" then
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
