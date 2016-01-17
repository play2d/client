Commands = {}
Commands.List = {}

function Commands.FindFunction(Name)
	local Command = Commands.List[Name]
	if Command then
		return Command.Call
	end
	
	if Core.State.ConVars then
		local CVar = Core.State.ConVars[Name]
		if CVar then
			return function (Source, Value)
				CVar.Value = tostring(Value)
			end
		end
	end
end

function parse(command, source)
	if type(command) == "string" then
		console.run(command, Commands.FindFunction, source or {source = "game"})
	end
end

function Commands.Load()
	for _, File in pairs(love.filesystem.getDirectoryItems("src/commands")) do
		if File:sub(-4) == ".lua" then
			
			local Command = string.match(File, "([%a|%_]+)%p(%a+)")
			local Path = "src/commands/"..File
			if love.filesystem.isFile(Path) then
				local Load, ErrorOrFunction = pcall(love.filesystem.load, Path)
				if Load then
					
					local Success, CommandOrError = pcall(ErrorOrFunction)
					if Success then
						Commands.List[string.lower(Command)] = CommandOrError
					else
						print("Lua Error [Command: "..Command.."]: "..CommandOrError)
					end
				else
					print("Lua Error [Command: "..Command.."]: "..Error)
				end
			end
		end
	end
	
	for _, Command in pairs(Commands.List) do
		if Command.Load then
			local Success, Error = pcall(Command.Load)
			if not Success then
				print("Lua Error [Command: "..Command.."]: "..Error)
			end
		end
	end
	Commands.Load = nil
end
