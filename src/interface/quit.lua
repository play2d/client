local Path, PLAY2D, Interface = ...
local Quit = {}

function Quit.load()
	
	Quit.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_quit"), 30, 470)
	
	function Quit.Label:OnMouseReleased()
		
		if Quit.Label.IsHover then
			
			Quit.Window.Hidden = nil
			Quit.Window:SetHover()
			
		end
		
	end
	
	Quit.Window = PLAY2D.gui.create("Window", Interface.Language:Get("label_quit"), PLAY2D.Main:GetWidth()/2 - 150, PLAY2D.Main:GetHeight()/2 - 50, 300, 100, PLAY2D.Main)
	Quit.Message = PLAY2D.gui.create("Label", Interface.Language:Get("quit_confirm"), 30, 30, 260, 40, Quit.Window)
	Quit.Yes = PLAY2D.gui.create("Button", Interface.Language:Get("quit_yes"), 30, 60, 110, 25, Quit.Window)
	Quit.No = PLAY2D.gui.create("Button", Interface.Language:Get("quit_no"), 160, 60, 110, 25, Quit.Window)
	
	Quit.Window.Hidden = true
	
	function Quit.Yes:OnMouseReleased()
		
		if self.IsHover then
			
			love.event.quit()
			
		end
		
	end
	
	function Quit.No:OnMouseReleased()
		
		if self.IsHover then
			
			Quit.Window.Hidden = true
			
		end
		
	end
	
	Quit.load = nil
	
end

return Quit