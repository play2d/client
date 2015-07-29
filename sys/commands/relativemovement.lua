if not CLIENT then
	return nil
end

config["relativemovement"] = 0

local Command = {
	Category = "Player"
}

function Command.Call(Source, RelativeMovement)
	if Source.source == "game" then
		if type(RelativeMovement) == "number" then
			config["relativemovement"] = RelativeMovement
		end
	end
end

function Command.GetSaveString()
	return "relativemovement " .. config["relativemovement"]
end

return Command
