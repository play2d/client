local Path, PLAY2D, Interface = ...
local Console = {}

function Console.load()
	
	Console.MaxLines = PLAY2D.Commands.List["consolemaxlines"]
	Console.Label = Interface.Desktop.CreateLabel(Interface.Language:Get("label_console"), 30, 250)
	
	function Console.Label:OnMouseReleased()
		
		if self.IsHover then
			
			Console.Window.Hidden = false
			Console.Window:SetHover()
			
		end
		
	end
	
	Console.Window = PLAY2D.gui.create("Window", Interface.Language:Get("label_console"), 200, 20, 580, 560, PLAY2D.Main)
	Console.Window.Hidden = true
	
	Console.Area = PLAY2D.gui.create("TextArea", 10, 35, Console.Window:GetWidth() - 20, Console.Window:GetHeight() - 70, Console.Window)
	Console.Input = PLAY2D.gui.create("TextField", 10, Console.Area:GetHeight() + 40, Console.Window:GetWidth() - 150, 20, Console.Window)
	Console.Send = PLAY2D.gui.create("Button", Interface.Language:Get("label_send"), Console.Window:GetWidth() - 130, Console.Area:GetHeight() + 40, 120, 20, Console.Window)
	
	Console.Area.Disabled = true
	
	Console.Print("test1")
	Console.Print("test2")
	
	Console.load = nil
	
end

function Console.Print(Message)
	
	local Max = Console.MaxLines:GetInt()
	
	Console.Area.Text:Add(Message.."\n")
	
end

return Console