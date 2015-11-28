Options.Player = {}

function Options.Player.ReloadSpraylogos()
	Options.Player.Spraylogos = {}
	for Item in lfs.dir("logos") do
		if lfs.attributes("logos/"..Item, "mode") == "file" then
			
			local Image = love.graphics.newImage("logos/"..Item)
			if Image then
				local Index = #Options.Player.Spraylogos + 1
				local Spraylogo = {Index = Index, File = Item, Image = Image}
				Options.Player.Spraylogos[Index] = Spraylogo
				
				if Config.CFG["spraylogo"] then
					if Item == Config.CFG["spraylogo"] then
						Options.Player.SetSpraylogo(Index)
					end
				elseif not Options.Player.Spraylogo then
					Options.Player.SetSpraylogo(Index)
				end
			end
		end
	end
end

function Options.Player.SetSpraylogo(Index)
	if Index > #Options.Player.Spraylogos then
		Index = next(Options.Player.Spraylogos)
	elseif Index <= 0 then
		Index = #Options.Player.Spraylogos
	end
	
	if Index then
		local Spraylogo = Options.Player.Spraylogos[Index]
		if Spraylogo then
			Options.Player.Spraylogo = Spraylogo
			Options.Player.SpraylogoImage.Image = Spraylogo.Image
			Options.Player.SpraylogoLabel:SetText(Lang.Get2("gui_options_player_spraylogo", {SPRAYLOGO = Spraylogo.File}))
		end
	end
end

function Options.Player.Okay()
	Config.CFG["name"] = Options.Player.NameField:GetText()
	
	if Options.Player.Spraylogo then
		Config.CFG["spraylogo"] = Options.Player.Spraylogo.File
	end
end

function Options.Player.Cancel()
	Options.Player.NameField:SetText(Config.CFG["name"])
	
	Options.Player.Spraylogo = nil
	Options.Player.ReloadSpraylogos()
end

function Options.Player.InitializeMenu()
	Options.Panels[1] = gui.CreatePanel(Lang.Get("gui_options_tab_player"), 10, 60, 650, 480, Options.Window)
	gui.CreateLabel(Lang.Get("gui_options_player_name"), 20, 30, Options.Panels[1])
	
	Options.Player.NameField = gui.CreateTextfield(20, 50, 200, 20, Options.Panels[1])
	Options.Player.NameField:SetText(Config.CFG["name"])
	
	Options.Player.SpraylogoImage = gui.CreateImage(nil, 40, 100, 32, 32, Options.Panels[1])
	Options.Player.SpraylogoLabel = gui.CreateLabel(Lang.Get2("gui_options_player_spraylogo", {SPRAYLOGO = ""}), 20, 80, Options.Panels[1])
	Options.Player.PrevSpraylogo = gui.CreateButton("<", 20, 110, 15, 15, Options.Panels[1])
	Options.Player.NextSpraylogo = gui.CreateButton(">", 77, 110, 15, 15, Options.Panels[1])
	
	function Options.Player.PrevSpraylogo:OnDrop()
		if Options.Player.Spraylogo then
			Options.Player.SetSpraylogo(Options.Player.Spraylogo.Index - 1)
		end
	end
	
	function Options.Player.NextSpraylogo:OnDrop()
		if Options.Player.Spraylogo then
			Options.Player.SetSpraylogo(Options.Player.Spraylogo.Index + 1)
		end
	end
	
	Options.Player.InitializeMenu = nil
	Options.Player.ReloadSpraylogos()
end