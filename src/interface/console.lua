local Path, PLAY2D, Interface = ...
local gui = PLAY2D.gui

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
	
	Console.Window = gui.create("Window", Interface.Language:Get("label_console"), 200, 20, 580, 560, PLAY2D.Main)
	Console.Window.Hidden = true
	
	Console.Area = gui.create("TextArea", 10, 35, Console.Window:GetWidth() - 20, Console.Window:GetHeight() - 70, Console.Window)
	Console.Input = gui.create("TextField", 10, Console.Area:GetHeight() + 40, Console.Window:GetWidth() - 150, 20, Console.Window)
	Console.Send = gui.create("Button", Interface.Language:Get("label_send"), Console.Window:GetWidth() - 130, Console.Area:GetHeight() + 40, 120, 20, Console.Window)
	
	function Console.Input:Enter()
		
		local Command = Console.Input:GetText()
		
		Console.Input:SetText("")
		Console.Print("> " .. Command)
		
		if PLAY2D.Console:Execute(Command) then
			
			Console.Print(PLAY2D.Console.Error, 255, 0, 0, 255)
			
		end
		
	end
	
	function Console.Send:OnMousePressed()
		
		local Command = Console.Input:GetText()
		
		Console.Input:SetText("")
		Console.Print("> " .. Command)
		
		if PLAY2D.Console:Execute(Command) then
			
			Console.Print(PLAY2D.Console.Error, 255, 0, 0, 255)
			
		end
		
	end
	
	Console.Area.Disabled = true
	
	Console.load = nil
	
end

function Console.Print(Message, R, G, B, A)
	
	local Max = Console.MaxLines:GetInt()
	
	if #Console.Area.Text.Line > Max then
		
		Console.Area.Text:Remove(1, Console.Area.Text:Get():find("\n"))
		
	end
	
	Console.Area.Text:Add(Message.."\n", nil, R, G, B, A)
	Console.Area.Changed = true
	
end

return Console