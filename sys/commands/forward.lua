if not CLIENT then
	return nil
end

local Command = {}

function Command.LoadLanguage()
	Binds.Create(Lang.Get("gui_binds_walkforward"), "+forward")
end

function Command.Call(Source)
end

return Command