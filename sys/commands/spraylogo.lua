local Source, File = ...

if Source.source == "game" then
	if type(File) == "string" then
		config["spraylogo"] = File

		if game.ui.Options then
			game.ReloadSpraylogos()
		end
	end
end
