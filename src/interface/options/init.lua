local Path, PLAY2D, Interface = ...
local Options = {}

Options.Player = PLAY2D.Require(Path.."/player", Interface, Options)
Options.Controls = PLAY2D.Require(Path.."/controls", Interface, Options)
Options.Game = PLAY2D.Require(Path.."/game", Interface, Options)
Options.Graphics = PLAY2D.Require(Path.."/graphics", Interface, Options)
Options.Sound = PLAY2D.Require(Path.."/sound", Interface, Options)
Options.Net = PLAY2D.Require(Path.."/net", Interface, Options)
Options.More = PLAY2D.Require(Path.."/more", Interface, Options)

function Options.load()
	
	Options.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_options"), 30, 400)
	
	function Options.Label:OnMouseReleased()
		
		if self.IsHover then
			
			Options.Window.Hidden = false
			Options.Window:SetHover()
			
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
	
	Options.OkayButton = PLAY2D.gui.create("Button", Interface.Language:Get("options_okay"), 260, 535, 100, 20, Options.Window)
	Options.CancelButton = PLAY2D.gui.create("Button", Interface.Language:Get("options_cancel"), 370, 535, 100, 20, Options.Window)
	
	function Options.OkayButton:OnMouseReleased()
		
		if self.IsHover then
			
			Options.Okay()
			
		end
		
	end
	
	function Options.CancelButton:OnMouseReleased()
		
		if self.IsHover then
			
			Options.Cancel()
			
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

function Options.Okay()
	
	Options.Player.Okay()
	Options.Controls.Okay()
	Options.Game.Okay()
	Options.Graphics.Okay()
	Options.Sound.Okay()
	Options.Net.Okay()
	Options.More.Okay()
	
	Options.Window.Hidden = true
	
	PLAY2D.Configuration.save()
	
end

function Options.Cancel()
	
	Options.Player.Cancel()
	Options.Controls.Cancel()
	Options.Game.Cancel()
	Options.Graphics.Cancel()
	Options.Sound.Cancel()
	Options.Net.Cancel()
	Options.More.Cancel()
	
	Options.Window.Hidden = true
	
end

return Options