if not CLIENT then
	return nil
end

local Command = {
	Category = "Player"
}

function Command.Call(Source, Name)
	if Source.source == "game" then
		if type(Name) == "string" then
			config["name"] = Name
			if game.ui.Options then
				game.ui.Options.NameField:SetText(config["name"])
			end
		end
	end
end

function Command.GetSaveString()
	return "name " .. config["name"]
end

return Command
