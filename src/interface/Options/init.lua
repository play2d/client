local Path, PLAY2D, Interface = ...
local Options = {}

Options.Player = PLAY2D.Require("interface/options/player", Interface, Options)
Options.Controls = PLAY2D.Require("interface/options/controls", Interface, Options)
Options.Game = PLAY2D.Require("interface/options/game", Interface, Options)
Options.Graphics = PLAY2D.Require("interface/options/graphics", Interface, Options)
Options.Sound = PLAY2D.Require("interface/options/sound", Interface, Options)
Options.Net = PLAY2D.Require("interface/options/net", Interface, Options)
Options.More = PLAY2D.Require("interface/options/more", Interface, Options)

function Options.load()
	
	Options.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_options"), 30, 350)
	
	function Options.Label:OnMouseReleased()
		
		if self.IsHover then
			
			Options.Window.Hidden = false
			
		end
		
	end
	
	Options.Window = PLAY2D.gui.create("Window", Interface.Language:Get("label_options"), 300, 20, 480, 560, PLAY2D.Main)
	Options.Window.Hidden = true
	
	Options.Tab = PLAY2D.gui.create("Tabber", 10, 30, Options.Window:GetWidth() - 20, 20, Options.Window)
	Options.Panel = {}
	
	function Options.Tab:OnSelect(Index)
		
		for _, Panel in pairs(Options.Panel) do
			
			Panel.Hidden = true
			
		end
		
		local Panel = Options.Panel[Index]
		
		if Panel then
			
			Panel.Hidden = nil
		
		end
		
	end
	
	Options.Player.load()
	Options.Controls.load()
	Options.Game.load()
	Options.Graphics.load()
	Options.Sound.load()
	Options.Net.load()
	Options.More.load()
	
	for i = 2, #Options.Panel do
		
		Options.Panel[i].Hidden = true
		
	end
	
	Options.Tab:Select(1)
	
	Options.load = nil
	
end

return Options