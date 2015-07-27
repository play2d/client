local Source, Name = ...

if Source.source == "game" then
	if type(Name) == "string" then
		config["name"] = Name
		if game.ui.Options then
			game.ui.Options.NameField:SetText(config["name"])
		end
	end
end
