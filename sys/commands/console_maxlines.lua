local Source, MaxLines = ...

if Source.source == "game" then
	if type(MaxLines) == "number" then
		game.Console.MaxLines = MaxLines
		config["console_maxlines"] = MaxLines
	end
end
