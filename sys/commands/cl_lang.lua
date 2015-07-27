local Source, Language = ...

if Source.source == "game" then
	if type(Language) == "string" then
		config["cl_lang"] = Language
	end
end
