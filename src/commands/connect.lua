if not CLIENT then
	return nil
end

local Command = {}

function Command.Call(Source, Address)
	if Source.source == "game" then
		if type(Address) == "string" then
			Core.Connect.ConnectTo(Address)
		end
	end
end

return Command
