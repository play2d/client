if not CLIENT then
	return nil
end

CFG["relativemovement"] = 0

local Command = {
	Category = "Player"
}

function Command.Call(Source, RelativeMovement)
	if Source.source == "game" then
		if type(RelativeMovement) == "number" then
			CFG["relativemovement"] = RelativeMovement
		end
	end
end

function Command.GetSaveString()
	return "relativemovement " .. CFG["relativemovement"]
end

return Command
