if not CLIENT then
	return nil
end

local Command = {
	Category = "Other"
}

function Command.Call(Source, ...)
	if Source.source == "game" then
		local Path = ...
		if type(Path) == "string" then
			Path = Path:lower()
			Config.CFG["cl_gui"] = Path
			
			if Options and Options.Panels then
				Options.Graphics.GUITheme:SetText(Path)
			end
		end
	end
end

function Command.GetSaveString()
	return "cl_gui " .. Config.CFG["cl_gui"]
end

return Command
