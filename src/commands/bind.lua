if not CLIENT then
	return nil
end

local Command = {
	Category = "Binds"
}

Config.CFG["bind"] = {}

function Command.Call(Source, Key, Bind)
	if Source.source == "game" then
		Config.CFG["bind"][Key] = Bind
	end
end

function Command.GetSaveString()
	local Binds = ""
	for Key, Binding in pairs(Config.CFG["bind"]) do
		Binds = Binds .. 'bind "'..Key..'" "'..Binding..'"'
		if next(Config.CFG["bind"], Key) then
			Binds = Binds .. "\n"
		end
	end
	return Binds
end

function Command.ParsePlus()
	local First = Interface.Desktop.CurrentFirst
	if First then
		if First.Writeable and not First.Disabled then
			return nil
		end
	end
	
	for Key, Binding in pairs(Config.CFG["bind"]) do
		if Binding:sub(1, 1) == "+" then
			if love.keyboard.isDown(Key) then
				parse(Binding:sub(2))
			end
		end
	end
end
Hook.Add("update", Command.ParsePlus)

function Command.ParseMinus(Key)
	local First = Interface.Desktop.CurrentFirst
	if First then
		if First.Writeable and not First.Disabled then
			return nil
		end
	end
	
	local Binding = Config.CFG["bind"][Key]
	if Binding and Binding:sub(1, 1) == "-" then
		parse(Binding:sub(2))
	end
end
Hook.Add("keyreleased", Command.ParseMinus)

function Command.ParseNormal(Key, isRepeat)
	if not isRepeat then
		local First = Interface.Desktop.CurrentFirst
		if First then
			if First.Writeable and not First.Disabled then
				return nil
			end
		end
		
		local Binding = Config.CFG["bind"][Key]
		if Binding then
			local BindingType = Binding:sub(1, 1)
			if BindingType ~= "+" and BindingType ~= "-" then
				parse(Binding)
			end
		end
	end
end
Hook.Add("keypressed", Command.ParseNormal)

return Command