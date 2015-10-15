if not CLIENT then
	return nil
end

local Command = {
	Category = "Player"
}

function Command.Call(Source, File)
	if Source.source == "game" then
		if type(File) == "string" then
			Config.CFG["spraylogo"] = File

			if Options and Options.Panels then
				Options.Player.ReloadSpraylogos()
			end
		end
	end
end

function Command.GetSaveString()
	return "spraylogo " .. Config.CFG["spraylogo"]
end

return Command
