console = {}

function console.parse(command)
	local Commands = {}
	local Index = 0

	local CMD
	local Argument
	local Arguments

	local function Next()
		Index = Index + 1
		return string.sub(command, Index, Index)
	end

	local function PushCommand()
		if CMD then
			table.insert(Commands, {Command = string.lower(CMD), Arguments = Arguments})
			CMD = nil
			Argument = nil
			Arguments = nil
		end
	end

	while Index < #command do
		local Character = Next()
		if Character == ";" then
			PushCommand()
		elseif not CMD then
			CMD = Character
			Character = Next()
			while #Character > 0 do
				if Character == " " then
					break
				else
					CMD = CMD .. Character
				end
				Character = Next()
			end

			if #CMD > 0 then
				Arguments = {}
			end
		elseif not Argument then
			if Character == "\"" or Character == "'" or Character == " " then
				Argument = ""
				local Separator = ""..Character
				Character = Next()
				while #Character > 0 do
					if Character == Separator then
						break
					else
						Argument = Argument .. Character
					end
					Character = Next()
				end
			else
				Argument = Character
				Character = Next()
				while #Character > 0 do
					if Character == " " then
						break
					else
						Argument = Argument .. Character
					end
					Character = Next()
				end
			end

			if Arguments and #Argument > 0 then
				local Int = tonumber(Argument)
				if Int then
					table.insert(Arguments, Int)
				else
					table.insert(Arguments, Argument)
				end
				Argument = nil
			end
		else
			break
		end
	end

	PushCommand()
	return Commands
end

function console.run(command, commandList, errorFunction)
	assert(type(command) == "string", "#1: expected string")
	assert(type(commandList) == "table", "#2: expected table")
	local Commands = console.parse(command)
	if next(Commands) then
		for _, CMD in pairs(Commands) do
			local Function = commandList[CMD.Command]
			if Function then
				Function(unpack(CMD.Arguments))
			elseif errorFunction then
				errorFunction(CMD.Command)
			end
		end
	end
end
