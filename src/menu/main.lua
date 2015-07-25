game.ui = {}

local function HighlightLabel(self)
	self:SetColor("Text", 255, 255, 255, 255)
end

local function NormalizeLabel(self)
	self:SetColor("Text", 150, 150, 150, 255)
end

local function InitializeMainMenu()
	game.ui.Desktop = gui.CreateDesktop(config["cl_gui"], love.graphics.newImage("gfx/splash.png"))
	
	game.ui.MainMenu = gui.CreateCanvas(0, 0, game.ui.Desktop:GetWidth(), game.ui.Desktop:GetHeight(), game.ui.Desktop)
	
	game.ui.ConsoleButton = gui.CreateLabel(language.get("gui_label_console"), 20, 200, game.ui.MainMenu)
	game.ui.ConsoleButton:SetColor("Text", 150, 150, 150, 255)
	game.ui.ConsoleButton.OnClick = game.ui.OpenConsole
	game.ui.ConsoleButton.MouseEnter = HighlightLabel
	game.ui.ConsoleButton.MouseExit = NormalizeLabel
	
	game.ui.QuickMatchButton = gui.CreateLabel(language.get("gui_label_quick_match"), 20, 240, game.ui.MainMenu)
	game.ui.QuickMatchButton:SetColor("Text", 150, 150, 150, 255)
	game.ui.QuickMatchButton.MouseEnter = HighlightLabel
	game.ui.QuickMatchButton.MouseExit = NormalizeLabel
	
	game.ui.FindServersButton = gui.CreateLabel(language.get("gui_label_find_servers"), 20, 280, game.ui.MainMenu)
	game.ui.FindServersButton:SetColor("Text", 150, 150, 150, 255)
	game.ui.FindServersButton.OnClick = game.ui.OpenServerBrowser
	game.ui.FindServersButton.MouseEnter = HighlightLabel
	game.ui.FindServersButton.MouseExit = NormalizeLabel
	
	game.ui.FriendsButton = gui.CreateLabel(language.get("gui_label_friends"), 20, 300, game.ui.MainMenu)
	game.ui.FriendsButton:SetColor("Text", 150, 150, 150, 255)
	game.ui.FriendsButton.MouseEnter = HighlightLabel
	game.ui.FriendsButton.MouseExit = NormalizeLabel
	
	game.ui.ChatButton = gui.CreateLabel(language.get("gui_label_chat"), 20, 320, game.ui.MainMenu)
	game.ui.ChatButton:SetColor("Text", 150, 150, 150, 255)
	game.ui.ChatButton.MouseEnter = HighlightLabel
	game.ui.ChatButton.MouseExit = NormalizeLabel
	
	game.ui.OptionsButton = gui.CreateLabel(language.get("gui_label_options"), 20, 360, game.ui.MainMenu)
	game.ui.OptionsButton:SetColor("Text", 150, 150, 150, 255)
	game.ui.OptionsButton.OnClick = game.ui.OpenOptionsMenu
	game.ui.OptionsButton.MouseEnter = HighlightLabel
	game.ui.OptionsButton.MouseExit = NormalizeLabel
	
	game.ui.HelpButton = gui.CreateLabel(language.get("gui_label_help"), 20, 380, game.ui.MainMenu)
	game.ui.HelpButton:SetColor("Text", 150, 150, 150, 255)
	game.ui.HelpButton.MouseEnter = HighlightLabel
	game.ui.HelpButton.MouseExit = NormalizeLabel
	
	game.ui.QuitButton = gui.CreateLabel(language.get("gui_label_quit"), 20, 420, game.ui.MainMenu)
	game.ui.QuitButton:SetColor("Text", 150, 150, 150, 255)
	game.ui.QuitButton.MouseEnter = HighlightLabel
	game.ui.QuitButton.MouseExit = NormalizeLabel
	
	HighlightLabel = nil
	NormalizeLabel = nil
	InitializeMainMenu = nil
end

Hook.Add("load", InitializeMainMenu)