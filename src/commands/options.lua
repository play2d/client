if not CLIENT then
	return nil
end

local Command = {}

function Command.Call()
	Interface.Options.Open()
end

return Command
