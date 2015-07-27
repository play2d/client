local Source, Path = ...

if Source.source == "game" then
	if type(Path) == "string" then
		config["cl_gui"] = Path
	end
end
