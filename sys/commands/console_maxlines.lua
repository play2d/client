if not CLIENT then
	return nil
end

local Command = {
	Category = "Other"
}

function Command.Call(Source, MaxLines)
	if Source.source == "game" then
		if type(MaxLines) == "number" then
			CFG["console_maxlines"] = MaxLines
			Console.MaxLines = MaxLines
		end
	end
end

function Command.GetSaveString()
	return "console_maxlines " .. CFG["console_maxlines"]
end

return Command
