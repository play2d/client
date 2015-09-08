local Path = ...

Interface = {}

function Interface.Load()
	Interface.Initialize()
	Interface.Console.Initialize()
	Interface.Servers.Initialize()
	Interface.Chat.Initialize()
	Interface.Options.Initialize()
	Interface.Quit.Initialize()
	
	Interface.Load = nil
end

require(Path..".console")
require(Path..".servers")
require(Path..".chat")
require(Path..".options")
require(Path..".quit")

local function HighlightLabel(self)
	self:SetColor("Text", 255, 255, 255, 255)
end

local function NormalizeLabel(self)
	self:SetColor("Text", 150, 150, 150, 255)
end

function Interface.Initialize()
	Interface.Desktop = gui.CreateDesktop(Config.CFG["cl_gui"], love.graphics.newImage("gfx/splash.png"))
	
	Interface.MainMenu = gui.CreateCanvas(0, 0, Interface.Desktop:GetWidth(), Interface.Desktop:GetHeight(), Interface.Desktop)
	
	Interface.ConsoleButton = gui.CreateLabel(Lang.Get("gui_label_console"), 20, 200, Interface.MainMenu)
	Interface.ConsoleButton:SetColor("Text", 150, 150, 150, 255)
	Interface.ConsoleButton.OnDrop = Interface.Console.Open
	Interface.ConsoleButton.MouseEnter = HighlightLabel
	Interface.ConsoleButton.MouseExit = NormalizeLabel
	
	Interface.QuickMatchButton = gui.CreateLabel(Lang.Get("gui_label_quick_match"), 20, 240, Interface.MainMenu)
	Interface.QuickMatchButton:SetColor("Text", 150, 150, 150, 255)
	Interface.QuickMatchButton.MouseEnter = HighlightLabel
	Interface.QuickMatchButton.MouseExit = NormalizeLabel
	
	Interface.FindServersButton = gui.CreateLabel(Lang.Get("gui_label_find_servers"), 20, 280, Interface.MainMenu)
	Interface.FindServersButton:SetColor("Text", 150, 150, 150, 255)
	Interface.FindServersButton.OnDrop = Interface.Servers.Open
	Interface.FindServersButton.MouseEnter = HighlightLabel
	Interface.FindServersButton.MouseExit = NormalizeLabel
	
	Interface.FriendsButton = gui.CreateLabel(Lang.Get("gui_label_friends"), 20, 300, Interface.MainMenu)
	Interface.FriendsButton:SetColor("Text", 150, 150, 150, 255)
	Interface.FriendsButton.MouseEnter = HighlightLabel
	Interface.FriendsButton.MouseExit = NormalizeLabel
	
	Interface.OptionsButton = gui.CreateLabel(Lang.Get("gui_label_options"), 20, 360, Interface.MainMenu)
	Interface.OptionsButton:SetColor("Text", 150, 150, 150, 255)
	Interface.OptionsButton.OnDrop = Interface.Options.Open
	Interface.OptionsButton.MouseEnter = HighlightLabel
	Interface.OptionsButton.MouseExit = NormalizeLabel
	
	Interface.HelpButton = gui.CreateLabel(Lang.Get("gui_label_help"), 20, 380, Interface.MainMenu)
	Interface.HelpButton:SetColor("Text", 150, 150, 150, 255)
	Interface.HelpButton.MouseEnter = HighlightLabel
	Interface.HelpButton.MouseExit = NormalizeLabel
	
	Interface.QuitButton = gui.CreateLabel(Lang.Get("gui_label_quit"), 20, 420, Interface.MainMenu)
	Interface.QuitButton:SetColor("Text", 150, 150, 150, 255)
	Interface.QuitButton.OnDrop = Interface.Quit.Open
	Interface.QuitButton.MouseEnter = HighlightLabel
	Interface.QuitButton.MouseExit = NormalizeLabel
	
	HighlightLabel = nil
	NormalizeLabel = nil
	Interface.InitializeMainMenu = nil
end