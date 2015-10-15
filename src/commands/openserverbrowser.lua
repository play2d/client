if not CLIENT then
	return nil
end

local Command = {}

function Command.Call()
	Interface.Servers.Open()
end

return Command
