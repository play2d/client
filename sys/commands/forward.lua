if not CLIENT then
	return nil
end

local Command = {}

function Command.LoadLanguage()
	game.ui.CreateBind(language.get("gui_binds_walkforward"), "forward")
end

function Command.Call(Source)
end

return Command