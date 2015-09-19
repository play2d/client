local Chat = {}
Chat.IP = "irc.quakenet.org"
Chat.Port = 6667
Chat.Channel = "#play2d"

Interface.Chat = {}
Interface.Chat.Line = {}
Interface.Chat.MaxLines = 200

function Interface.Chat.Initialize()
	Interface.Chat.Panel = gui.CreatePanel(Lang.Get("gui_label_chat"), 115, 400, 600, 190, Interface.MainMenu)
	Interface.Chat.Panel:SetColor("Text", 200, 200, 200, 200)
	Interface.Chat.Panel:SetColor("Background", 100, 100, 100, 30)
	
	Interface.Chat.Area = gui.CreateTextarea(10, 20, 450, 130, Interface.Chat.Panel)
	Interface.Chat.Area:SetColor("Text", 200, 200, 200, 200)
	Interface.Chat.Area:SetColor("Background", 100, 100, 100, 50)
	Interface.Chat.Area:SetColor("SliderArea", 150, 150, 150, 80)
	Interface.Chat.Area.Disabled = true
	
	Interface.Chat.UserList = gui.CreateListbox(470, 20, 120, 130, Interface.Chat.Panel)
	Interface.Chat.UserList:SetColor("Text", 50, 150, 150, 150)
	Interface.Chat.UserList:SetColor("Background", 150, 150, 150, 50)
	
	Interface.Chat.Input = gui.CreateTextfield(10, 160, 480, 20, Interface.Chat.Panel, "Write a text here")
	Interface.Chat.Input:SetColor("Text", 255, 255, 255, 150)
	Interface.Chat.Input:SetColor("Background", 150, 150, 150, 50)
	
	Interface.Chat.Send = gui.CreateButton("Send", 500, 160, 90, 20, Interface.Chat.Panel)
	Interface.Chat.Send:SetColor("Text", 200, 200, 200, 200)
	Interface.Chat.Send:SetColor("Top", 200, 200, 200, 100)
	Interface.Chat.Send:SetColor("Bottom", 150, 150, 150, 100)

	Interface.Chat.Initialize = nil
	Chat.Connect()
end

function Interface.Chat.Print(Text, R, G, B, A)
	if Text then
		if #Interface.Chat.Line >= Interface.Chat.MaxLines then
			for Index, Format in pairs(Interface.Chat.Area.Format) do
				Format.Start = Format.Start - #Interface.Chat.Line[1] - 1
				if Format.Start < 0 then
					if Format.Start + Format.Length < 0 then
						Interface.Chat.Area.Format[Index] = nil
					else
						Format.Start = 0
					end
				end
			end
			Interface.Chat.Line[1] = nil
			
			local Lines = {}
			for _, Line in pairs(Interface.Chat.Line) do
				table.insert(Lines, Line)
			end
			Interface.Chat.Line = Lines
		end
		
		local ChatText = table.concat(Interface.Chat.Line, "\n")
		if R or G or B or A then
			if #ChatText > 0 then
				Interface.Chat.Area:SetFormat(#ChatText + 1, #Text + 1, Interface.Chat.Area:GetFont(), R or 255, G or 255, B or 255, A or 255)
			else
				Interface.Chat.Area:SetFormat(1, #Text, Interface.Chat.Area:GetFont(), R or 255, G or 255, B or 255, A or 255)
			end
		end
		
		table.insert(Interface.Chat.Line, Text)
		if #ChatText > 0 then
			Interface.Chat.Area:SetText(ChatText .. "\n" .. Text)
		else
			Interface.Chat.Area:SetText(Text)
		end
		
		if not Interface.Chat.Area.Slider.Vertical.Hidden and not Interface.Chat.Area.Slider.Vertical.Grabbed then
			Interface.Chat.Area.Slider.Vertical.Value = Interface.Chat.Area.Slider.Vertical.Values.Max
		end
	end
end

function Chat.Send(Message)
	Chat.Socket:send(Message.."\n")
end

function Chat.SendChat(Message)
	Chat.Send("PRIVMSG "..Chat.Channel.." : "..Message)
end

function Chat.SortNames(NameA, NameB)
	if NameA:sub(1, 1) == "@" and NameB:sub(1, 1) ~= "@" then
		return true
	elseif NameA:sub(1, 1) ~= "@" and NameB:sub(1, 1) == "@" then
		return false
	elseif NameA:sub(1, 1) == "@" and NameB:sub(1, 1) == "@" then
		local LowestLength = math.min(#NameA, #NameB)
		for i = 2, LowestLength do
			if NameA:byte(i) < NameB:byte(i) then
				return true
			end
		end
		return true
	end
	local LowestLength = math.min(#NameA, #NameB)
	for i = 1, LowestLength do
		if NameA:byte(i) < NameB:byte(i) then
			return true
		end
	end
	return true
end

function Chat.Update()
	if Chat.Socket then
		local Message, Error = Chat.Socket:receive("*l")
		if Error == "closed" then
			Chat.Socket = nil
			Chat.InChat = nil
			Chat.Nick = nil
			
			Interface.Chat.Print("Disconnected", 200, 50, 50, 255)
			return nil
		elseif Error == "timeout" then
			return nil
		end
		
		local Split = Message:split()
		if Split[1] == "PING" then
			Chat.Send("PONG "..Split[2]:sub(2))
			return nil
		end
		
		if Message:sub(1, 1) == ":" then
			Message = Message:sub(2)
		end
		
		local Ar = {Message:find(":")}
		local ChatMessage
		if Ar[1] == nil then
			ChatMessage = Message
		else
			ChatMessage = Message:sub(Ar[1] + 1)
		end
		
		local Def = Message:sub(1, Ar[1])
		
		Ar[2] = Def:find(" ")
		local FirstString = Def:sub(1, Ar[2])
		
		Ar[3] = Def:find("!")
		local Nick = ""
		if Ar[3] then
			Nick = Def
			while Ar[3] do
				Nick = Nick:sub(1, Ar[3] - 1)
				Ar[3] = Nick:find("!")
			end
		end
		
		Ar[4] = Message:find(" ")
		local Command = ""
		if Ar[4] then
			Command = Message:sub(Ar[4] + 1)
		end
		
		Ar[5] = Command:find(" ")
		local Comp = ""
		if Ar[5] then
			Comp = Command:sub(Ar[5] + 1)
		end
		
		if Def:find("PRIVMSG") then
			if ChatMessage:sub(1, 7) == "ACTION" then
				Interface.Chat.Print(Nick.." "..ChatMessage:sub(9))
			elseif #Nick > 0 then
				Interface.Chat.Print(Nick..": "..ChatMessage)
			else
				Interface.Chat.Print(ChatMessage)
			end
		elseif Def:find("NOTICE") then
			Interface.Chat.Print("* "..Nick.." Notice: "..ChatMessage)
		elseif Command:sub(1, 4) == "JOIN" then
			Interface.Chat.Print(Nick.." has joined to the IRC channel", 200, 200, 50, 255)
		elseif Command:sub(1, 4) == "PART" then
			Interface.Chat.Print(Nick.." has left the IRC channel", 200, 50, 50, 255)
		elseif Command:sub(1, 4) == "QUIT" then
			Interface.Chat.Print(Nick.." has left the IRC channel", 200, 50, 50, 255)
		elseif Command:sub(1, 4) == "MODE" then
			Interface.Chat.Print(Nick.." sets mode: "..Comp, 50, 50, 200, 255)
		elseif Command:match("(%d+)") == "353" then
			Comp = Comp:sub(Comp:find(":") + 1)
			
			local NamesList = {}
			for _, Name in pairs(Comp:split()) do
				table.insert(NamesList, Name)
			end
			table.sort(NamesList, Chat.SortNames)
			
			Interface.Chat.UserList:ClearItems()
			for _, Name in pairs(NamesList) do
				Interface.Chat.UserList:AddItem(Name)
			end
		elseif ChatMessage == "End of /MOTD command." then
			Chat.InChat = true
			Chat.Send("JOIN "..Chat.Channel)
			Chat.Send("NAMES "..Chat.Channel)
		end
	end
end

function Chat.Connect()
	if not Chat.Socket then
		Chat.Socket = socket.tcp()
		Chat.Socket:settimeout(2500)
		
		local Bind, Error = Chat.Socket:bind("*", 0)
		if not Bind then
			Interface.Chat.Print("Error: "..Error, 200, 50, 50, 255)
			Chat.Socket = nil
			return nil
		end
		
		local Connect, Error = Chat.Socket:connect(Chat.IP, Chat.Port)
		if not Connect then
			Interface.Chat.Print("Error: "..Error, 200, 50, 50, 255)
			Chat.Socket = nil
			return nil
		end
		Interface.Chat.Print("Connected", 50, 200, 50, 255)
		
		Chat.Socket:settimeout(0)
		Chat.Nick = Config.CFG["name"]
		
		Chat.Send("USER "..game.VERSION:gsub("%p", "").." 127.0.0.1 "..Chat.IP.." :Play2D")
		Chat.Send("NICK "..Chat.Nick)
		Chat.Send("PONG ")
	end
end

Hook.Add("update", Chat.Update)