if not CLIENT then
	return nil
end

local Command = {
	Category = "Player"
}

function Command.Call(Source, File)
	if Source.source == "game" then
		if type(File) == "string" then
			config["spraylogo"] = File

			if game.ui.Options then
				game.ReloadSpraylogos()
			end
		end
	end
end

function Command.GetSaveString()
	return "spraylogo " .. config["spraylogo"]
end

return Command
