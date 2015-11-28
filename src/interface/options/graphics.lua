Options.Graphics = {}

function Options.Graphics.Okay()
	local Theme = Options.Graphics.GUITheme:GetText()
	if Interface.Desktop:LoadTheme(Theme) then
		Config.CFG["cl_gui"] = Theme
	else
		Options.Graphics.GUITheme:SetText(Config.CFG["cl_gui"])
	end
end

function Options.Graphics.Cancel()
	Options.Graphics.GUITheme:SetText(Config.CFG["cl_gui"])
end

function Options.Graphics.InitializeMenu()
	Options.Panels[4] = gui.CreatePanel(Lang.Get("gui_options_tab_graphics"), 10, 60, 650, 480, Options.Window)
	
	gui.CreateLabel(Lang.Get("gui_options_graphics_guithemepath"), 20, 30, Options.Panels[4])
	
	Options.Graphics.GUITheme = gui.CreateCombofield(20, 50, 300, 20, Options.Panels[4])
	Options.Graphics.GUITheme:SetText(Config.CFG["cl_gui"])
	
	for File in lfs.dir("gfx/gui") do
		if lfs.attributes("gfx/gui/"..File, "mode") == "file" then
			local ScriptFile = "gfx/gui/"..File.."/main.lua"
			if lfs.attributes(ScriptFile, "mode") == "file" then
				Options.Graphics.GUITheme:AddItem(ScriptFile)
			end
		end
	end
end