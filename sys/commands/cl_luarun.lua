local Arg = {...}
local Source = Arg[1]

if Source.source == "game" then
	Arg[1] = nil

	local Script = table.concat(Arg, " ")
	if #Script > 0 then
		local f, Error = loadstring(Script)
		if Error then
			return game.Console.Print(Error, 255, 0, 0, 255)
		end

		local Success, Error = pcall(f)
		if not Success then
			return game.Console.Print(Error, 255, 0, 0, 255)
		end
	end
end
