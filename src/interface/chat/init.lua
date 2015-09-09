Interface.Chat = {}

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
	Interface.Chat.UserList:SetColor("Background", 150, 150, 150, 50)
	
	Interface.Chat.Input = gui.CreateTextfield(10, 160, 480, 20, Interface.Chat.Panel, "Write a text here")
	Interface.Chat.Input:SetColor("Text", 255, 255, 255, 150)
	Interface.Chat.Input:SetColor("Background", 150, 150, 150, 50)
	
	Interface.Chat.Send = gui.CreateButton("Send", 500, 160, 90, 20, Interface.Chat.Panel)
	Interface.Chat.Send:SetColor("Text", 200, 200, 200, 200)
	Interface.Chat.Send:SetColor("Top", 200, 200, 200, 100)
	Interface.Chat.Send:SetColor("Bottom", 150, 150, 150, 100)

	Interface.Chat.Initialize = nil
end