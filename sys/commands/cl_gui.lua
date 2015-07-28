if not CLIENT then
	return nil
end

local Command = {
	Category = "Other"
}

function Command.Call(Source, ...)
	if Source.source == "game" then
		local Path = ...
		if type(Path) == "string" then
			config["cl_gui"] = Path
		end
	end
end

function Command.GetSaveString()
	return "cl_gui " .. config["cl_gui"]
end

return Command
