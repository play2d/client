Options.Player = {}

function Options.Player.ReloadSpraylogos()
	Options.Player.Spraylogos = {}
	for _, Item in pairs(love.filesystem.getDirectoryItems("logos")) do
		if love.filesystem.isFile("logos/"..Item) then
			
			local Image = love.graphics.newImage("logos/"..Item)
			if Image then
				local Index = #Options.Player.Spraylogos + 1
				local Spraylogo = {Index = Index, File = Item, Image = Image}
				Options.Player.Spraylogos[Index] = Spraylogo
				
				if config["spraylogo"] then
					if Item == config["spraylogo"] then
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
			Options.Player.SpraylogoLabel:SetText(language.get2("gui_options_player_spraylogo", {SPRAYLOGO = Spraylogo.File}))
		end
	end
end

function Options.Player.Okay()
	config["name"] = Options.Player.NameField:GetText()
	
	if Options.Player.Spraylogo then
		config["spraylogo"] = Options.Player.Spraylogo.File
	end
end

function Options.Player.Cancel()
	Options.Player.NameField:SetText(config["name"])
	
	Options.Player.Spraylogo = nil
	Options.Player.ReloadSpraylogos()
end

function Options.Player.InitializeMenu()
	Options.Panels[1] = gui.CreatePanel(language.get("gui_options_tab_player"), 10, 60, 650, 480, Options.Window)
	gui.CreateLabel(language.get("gui_options_player_name"), 20, 30, Options.Panels[1])
	
	Options.Player.NameField = gui.CreateTextfield(20, 50, 200, 20, Options.Panels[1])
	Options.Player.NameField:SetText(config["name"])
	
	Options.Player.SpraylogoImage = gui.CreateImage(nil, 40, 100, 32, 32, Options.Panels[1])
	Options.Player.SpraylogoLabel = gui.CreateLabel(language.get2("gui_options_player_spraylogo", {SPRAYLOGO = ""}), 20, 80, Options.Panels[1])
	Options.Player.PrevSpraylogo = gui.CreateButton("<", 20, 110, 15, 15, Options.Panels[1])
	Options.Player.NextSpraylogo = gui.CreateButton(">", 77, 110, 15, 15, Options.Panels[1])
	
	function Options.Player.PrevSpraylogo:OnClick()
		if Options.Player.Spraylogo then
			Options.SetSpraylogo(Options.Player.Spraylogo.Index - 1)
		end
	end
	
	function Options.Player.NextSpraylogo:OnClick()
		if Options.Player.Spraylogo then
			Options.Player.SetSpraylogo(Options.Player.Spraylogo.Index + 1)
		end
	end
	
	Options.Player.InitializeMenu = nil
	Options.Player.ReloadSpraylogos()
end