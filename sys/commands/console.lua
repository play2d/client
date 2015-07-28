if not CLIENT then
	return nil
end

local Command = {}

function Command.Call()
	game.ui.OpenConsole()
end

return Command
