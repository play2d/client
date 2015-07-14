commands = {}
commands.list = {}

function parse(command)
	if type(command) == "string" then
		console.run(command, commands.list)
	end
end

function commands.load()
	for File in lfs.dir("sys/commands") do -- CODE CRASHES HERE
		if File ~= "." and File ~= ".." then
			local Command = string.match(File, "(%a+)%p(%a+)")
			local Path = "sys/commands/"..File
			if lfs.attributes(Path, "mode") == "file" then
				local Okay, f = loadfile(Path)
				if Okay then
					commands.list[string.lower(Command)] = f
				else
					print("Lua Error [Command: "..Command.."]: "..f)
				end
			end
		end
	end
	commands.load = nil
end

Hook.Add("load", commands.load)
