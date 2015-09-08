Interface.Chat = {}

function Interface.Chat.Initialize()
	Interface.Chat.Panel = gui.CreatePanel(Lang.Get("gui_label_chat"), 120, 20, 600, 190, Interface.MainMenu)
	Interface.Chat.Panel:SetColor("Text", 200, 200, 200, 200)
	Interface.Chat.Panel:SetColor("Background", 255, 255, 255, 10)
	
	Interface.Chat.Area = gui.CreateTextarea(10, 20, 450, 130, Interface.Chat.Panel)
	Interface.Chat.Area.Disabled = true
	
	Interface.Chat.UserList = gui.CreateListbox(470, 20, 120, 130, Interface.Chat.Panel)
	
	Interface.Chat.Input = gui.CreateTextfield(10, 160, 480, 20, Interface.Chat.Panel, "Write a text here")
	
	Interface.Chat.Send = gui.CreateButton("Send", 500, 160, 90, 20, Interface.Chat.Panel)

	Interface.Chat.Initialize = nil
end