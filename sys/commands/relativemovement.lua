local Source, RelativeMovement = ...

if Source.source == "game" then
	if type(RelativeMovement) == "number" then
		config["relativemovement"] = RelativeMovement
	end
end
