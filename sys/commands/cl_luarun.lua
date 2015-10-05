if not CLIENT then
	return nil
end

local Command = {}

function Command.Call(Source, ...)
	if Source.source == "game" then
		local Arg = {...}
		local Script = table.concat(Arg, " ")
		if #Script > 0 then
			local f, Error = loadstring(Script)
			if Error then
				return Console.Print(Error, 255, 0, 0, 255)
			end

			local Success, Error = pcall(f)
			if not Success then
				return Console.Print(Error, 255, 0, 0, 255)
			end
		end
	end
end

return Command
