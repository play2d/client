local File = ...

if type(File) == "string" then
	config["spraylogo"] = File
	
	if game.ui.Options then
		game.ReloadSpraylogos()
	end
end
