ffi = require("ffi")
require("modules.hook")
require("modules.console")
require("modules.string")
require("modules.gui")
require("enet")

-- Game
game = {
	VERSION = "0.0.0.1a";			-- Version String
	CODENAME = "Lua rox";		-- Version codename
	DATE = "13/07/2015";		-- Last update
}

require("game.constants")
require("game.commands")
require("game.config")
require("game.language")
require("game.vector")

-- GUI
game.Desktop = gui.CreateDesktop("gfx/gui/Default/main.lua")
game.Window = gui.CreateWindow("Test window", 100, 100, 300, 450, game.Desktop, true)
game.Button = gui.CreateButton("Button", 10, 30, 100, 20, game.Window)
game.SliderVer = gui.CreateSlider(gui.SLIDER_VER, 200, 30, 12, 100, game.Window, 10, 30)
game.SliderHor = gui.CreateSlider(gui.SLIDER_HOR, 10, 140, 100, 12, game.Window, 10, 30)
game.Checkbox = gui.CreateCheckbox("Test checkbox", 10, 60, 15, 15, game.Window)
game.Tabber = gui.CreateTabber(10, 90, game.Window)
game.Tabber:AddItem("Tabber")
game.Tabber:AddItem("Colored Tabber", 255, 80, 80, 127, 2)
game.Tabber:AddItem("Item")
game.Image = gui.CreateImage(love.graphics.newImage("game/icon.png"), 10, 160, 64, 64, game.Window)
game.Label = gui.CreateLabel("Test label", 10, 230, game.Window)
game.Textfield = gui.CreateTextfield(10, 260, 100, 20, game.Window)
game.TextfieldP = gui.CreateTextfield(10, 285, 100, 20, game.Window)
game.TextfieldP.Password = true
game.Window2 = gui.CreateWindow("Test window2", 320, 50, 200, 300, game.Desktop, true)
game.Listbox = gui.CreateListbox(10, 30, 180, 260, game.Window2)
for i = 1, 15 do
	game.Listbox:AddItem("test item "..i)
end
game.Combobox = gui.CreateCombobox(10, 310, 200, 20, game.Window)
game.Combofield = gui.CreateCombofield(10, 340, 200, 20, game.Window)
for i = 1, 5 do
	game.Combobox:AddItem("test item "..i)
	game.Combofield:AddItem("test item "..i)
end
game.Progress = gui.CreateProgressbar(10, 370, 200, 20, game.Window)
game.Progress.Progress = 100
game.Progress.Text = "Downloading"
game.Window3 = gui.CreateWindow("Another test window", 530, 50, 200, 300, game.Desktop, true)
game.Listview = gui.CreateListview(10, 30, 260, game.Window3)
game.Listview:AddColumn("test", 90)
game.Listview:AddColumn("test2", 90)
for i = 1, 20 do
	game.Listview:AddItem("label "..i, "something "..(20 - i))
end

-- Desktop test
game.StartButton = gui.CreateButton("Start", 10, 10, 100, 20, game.Desktop)
function game.StartButton:OnClick()
	local StartWindow = gui.CreateWindow("Start Game", 100, 100, 200, 100, game.Desktop, true)
	local Label = gui.CreateLabel("Name:", 10, 30, StartWindow)
	local Textfield = gui.CreateTextfield(60, 30, 100, 20, StartWindow)
	local Button = gui.CreateButton("Go Play", 10, 60, 100, 20, StartWindow)

	function Button:OnClick()
		StartWindow:Hide()
	end
end

love.graphics.max = 60
