if not CLIENT then
	return nil
end

Config.CFG["name"] = "Player"

local Command = {
	Category = "Player"
}

function Command.Call(Source, Name)
	if Source.source == "game" then
		if type(Name) == "string" then
			Config.CFG["name"] = Name
			
			if Options and Options.Panels then
				Options.Player.NameField:SetText(config["name"])
			end
		end
	end
end

function Command.GetSaveString()
	return "name " .. Config.CFG["name"]
end

return Command
