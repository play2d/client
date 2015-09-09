Console = {}
Console.Line = {}
Console.MaxLines = 300

Interface.Console = {}

function Console.Print(Text, R, G, B, A)
	if Text then
		local Text = tostring(Text)
		if #Console.Line >= Console.MaxLines then
			for Index, Format in pairs(Interface.ConsoleOutput.Format) do
				Format.Start = Format.Start - #Console.Line[1] - 1
				if Format.Start < 0 then
					if Format.Start + Format.Length < 0 then
						Interface.ConsoleOutput.Format[Index] = nil
					else
						Format.Start = 0
					end
				end
			end
			Console.Line[1] = nil
			
			local Lines = {}
			for _, Line in pairs(Console.Line) do
				table.insert(Lines, Line)
			end
			Console.Line = Lines
		end
		local ConsoleText = table.concat(Console.Line, "\n")
		if R or G or B or A then
			Interface.ConsoleOutput:SetFormat(#ConsoleText + 1, #Text + 1, Interface.ConsoleOutput:GetFont(), R or 255, G or 255, B or 255, A or 255)
		end
		table.insert(Console.Line, Text)
		if #ConsoleText > 0 then
			Interface.ConsoleOutput:SetText(ConsoleText .. "\n" .. Text)
		else
			Interface.ConsoleOutput:SetText(Text)
		end
	end
end

function Interface.Console.Open()
	Interface.Console.Hidden = nil
	Interface.ConsoleInput:Focus()
end

function Interface.Console.Initialize()
	if type(Config.CFG["console_maxlines"]) == "number" then
		Console.MaxLines = Config.CFG["console_maxlines"]
	end
	Interface.Console = gui.CreateWindow(Lang.Get("gui_label_console"), 290, 10, 500, 580, Interface.Desktop, true)
	Interface.Console.Hidden = true
	
	Interface.ConsoleSend = gui.CreateButton(Lang.Get("gui_label_send"), 390, 550, 100, 20, Interface.Console)
	function Interface.ConsoleSend:OnDrop()
		local Command = Interface.ConsoleInput:GetText()
		Interface.ConsoleInput:SetText("")
		Interface.ConsoleInput:Focus()
		parse(Command)
		Console.Print("> "..Command)
	end

	Interface.ConsoleOutput = gui.CreateTextarea(10, 30, 480, 510, Interface.Console)
	Interface.ConsoleOutput:SetColor("Text", 120, 120, 120, 255)
	Interface.ConsoleOutput.Disabled = true
	
	Interface.ConsoleInput = gui.CreateTextfield(10, 550, 370, 20, Interface.Console)
	function Interface.ConsoleInput:Send()
		local Command = Interface.ConsoleInput:GetText()
		Interface.ConsoleInput:SetText("")
		parse(Command)
		Console.Print("> "..Command)
	end
	Console.Print("Play2D "..game.VERSION.." ["..game.CODENAME.."] initialized", 0, 200, 0, 255)
	
	Interface.Console.Initialize = nil
end