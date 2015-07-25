local Name = ...

if type(Name) == "string" then
	config["name"] = Name
	if game.ui.Options then
		game.ui.Options.NameField:SetText(config["name"])
	end
end
