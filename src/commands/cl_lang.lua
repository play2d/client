if not CLIENT then
	return nil
end

local Command = {
	Category = "Other"
}

function Command.Call(Source, Language)
	if Source.source == "game" then
		if type(Language) == "string" then
			Config.CFG["cl_lang"] = Language
		end
	end
end

function Command.GetSaveString()
	return "cl_lang " .. Config.CFG["cl_lang"]
end

return Command
