if not CLIENT then
	return nil
end

CFG["name"] = "Player"

local Command = {
	Category = "Player"
}

function Command.Call(Source, Name)
	if Source.source == "game" then
		if type(Name) == "string" then
			CFG["name"] = Name
			if Options then
				Options.Player.NameField:SetText(config["name"])
			end
		end
	end
end

function Command.GetSaveString()
	return "name " .. CFG["name"]
end

return Command
