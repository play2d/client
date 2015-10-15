Commands = {}
Commands.List = {}
Commands.FunctionList = {}

function parse(command, source)
	if type(command) == "string" then
		console.run(command, Commands.FunctionList, source or {source = "game"})
	end
end

function Commands.Load()
	local FunctionListMetatable = {}
	function FunctionListMetatable:__index(Command)
		if Commands.List[Command] then
			return Commands.List[Command].Call
		end
	end
	setmetatable(Commands.FunctionList, FunctionListMetatable)

	local Files = love.filesystem.getDirectoryItems("sys/commands")
	for _, File in pairs(Files) do
		if File:sub(-4) == ".lua" then
			
			local Command = string.match(File, "([%a|%_]+)%p(%a+)")
			local Path = "sys/commands/"..File
			if love.filesystem.isFile(Path) then
				local Load, Error = loadfile(Path)
				if Load then
					setfenv(Load, Namespace.Commands)
					
					local Success, CommandOrError = pcall(Load)
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
	
	local Files = love.filesystem.getDirectoryItems("src/commands")
	for _, File in pairs(Files) do
		if File:sub(-4) == ".lua" then
			
			local Command = string.match(File, "([%a|%_]+)%p(%a+)")
			local Path = "src/commands/"..File
			if love.filesystem.isFile(Path) then
				local Load, Error = loadfile(Path)
				if Load then
					
					local Success, CommandOrError = pcall(Load)
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
