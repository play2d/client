if not CLIENT then
	return nil
end

local Command = {}

function Command.Call()
	Interface.Console.Open()
end

return Command
