config = {}

function config.load()
	local File = io.open("sys/client.cfg", "r")
	if File then
		for Command in File:lines() do
			if Command:sub(1, 2) ~= "//" then
				parse(Command)
			end
		end
		File:close()
	end
	config.load = nil
end

function config.save()
	local File = io.open("sys/client.cfg", "w")
	if File then
		local CommandCategories = {}
		for Command, Memory in pairs(Commands.List) do
			if Memory.Category and Memory.GetSaveString then
				local Category = CommandCategories[Memory.Category]
				if not Category then
					Category = {}
					CommandCategories[Memory.Category] = Category
				end
				
				local Line = Memory.GetSaveString()
				if Line and #Line > 0 then
					table.insert(Category, Line)
				end
			end
		end
		
		for Category, Memory in pairs(CommandCategories) do
			if next(Memory) then
				local Lines = "// "..Category.."\n" .. table.concat(Memory, "\n")
				if next(CommandCategories, Category) then
					Lines = Lines .. "\n\n"
				end
				File:write(Lines)
			end
		end
		File:close()
	end
end

Hook.Add("load", config.load)
