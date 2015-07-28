if not CLIENT then
	return nil
end

local Command = {}

function Command.Call()
	game.ui.OpenOptionsMenu()
end

return Command
