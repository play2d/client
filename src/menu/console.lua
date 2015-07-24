game.Console = {}
game.Console.Line = {}
game.Console.MaxLines = 300

function game.Console.Print(Text, R, G, B, A)
	if Text then
		local Text = tostring(Text)
		if #game.Console.Line >= game.Console.MaxLines then
			for Index, Format in pairs(game.ui.ConsoleOutput.Format) do
				Format.Start = Format.Start - #game.Console.Line[1] - 1
				if Format.Start < 0 then
					if Format.Start + Format.Length < 0 then
						game.ui.ConsoleOutput.Format[Index] = nil
					else
						Format.Start = 0
					end
				end
			end
			game.Console.Line[1] = nil
			
			local Lines = {}
			for _, Line in pairs(game.Console.Line) do
				table.insert(Lines, Line)
			end
			game.Console.Line = Lines
		end
		local ConsoleText = table.concat(game.Console.Line, "\n")
		if R or G or B or A then
			game.ui.ConsoleOutput:SetFormat(#ConsoleText + 1, #Text, game.ui.ConsoleOutput:GetFont(), R or 255, G or 255, B or 255, A or 255)
		end
		table.insert(game.Console.Line, Text)
		if #ConsoleText > 0 then
			game.ui.ConsoleOutput:SetText(ConsoleText .. "\n" .. Text)
		else
			game.ui.ConsoleOutput:SetText(Text)
		end
	end
end

function game.ui.OpenConsole()
	game.ui.Console.Hidden = nil
end

local function InitializeConsoleMenu()
	game.ui.Console = gui.CreateWindow(language.get("gui_label_console"), 290, 10, 500, 580, game.ui.Desktop, true)
	game.ui.Console.Hidden = true
	
	game.ui.ConsoleSend = gui.CreateButton(language.get("gui_label_send"), 390, 550, 100, 20, game.ui.Console)
	function game.ui.ConsoleSend:OnClick()
		local Command = game.ui.ConsoleInput:GetText()
		parse(Command)
		game.ui.ConsoleInput:SetText("")
		game.ui.ConsoleInput:SetHoverAll()
		game.Console.Print("> "..Command)
	end

	game.ui.ConsoleOutput = gui.CreateTextarea(10, 30, 480, 510, game.ui.Console)
	game.ui.ConsoleOutput.Disabled = true
	
	game.ui.ConsoleInput = gui.CreateTextfield(10, 550, 370, 20, game.ui.Console)
	function game.ui.ConsoleInput:Send()
		local Command = game.ui.ConsoleInput:GetText()
		parse(Command)
		game.ui.ConsoleInput:SetText("")
		game.Console.Print("> "..Command)
	end
	
	InitializeConsoleMenu = nil
end

Hook.Add("load", InitializeConsoleMenu)