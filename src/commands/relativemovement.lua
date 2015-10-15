if not CLIENT then
	return nil
end

Config.CFG["relativemovement"] = 0

local Command = {
	Category = "Player"
}

function Command.Call(Source, RelativeMovement)
	if Source.source == "game" then
		if type(RelativeMovement) == "number" then
			Config.CFG["relativemovement"] = RelativeMovement
		end
	end
end

function Command.GetSaveString()
	return "relativemovement " .. Config.CFG["relativemovement"]
end

return Command
