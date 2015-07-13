-- Modules
if jit.arch == "x86" then
	if jit.os == "Windows" then
		package.cpath = ";./bin/win/?.dll"
		package.path = ";./bin/win/?.lua"
	elseif jit.os == "OSX" then
		package.cpath = ";./bin/osx/?.so"
		package.path = ";./bin/osx/?.lua"
	else
		package.cpath = ";./bin/linux/?.so"
		package.path = ";./bin/linux/?.lua"
	end
elseif jit.arch == "x64" then
	if jit.os == "Windows" then
		package.cpath = ";./bin/win64/?.dll"
		package.path = ";./bin/win64/?.lua"
	elseif jit.os == "OSX" then
		package.cpath = ";./bin/osx64/?.so"
		package.path = ";./bin/osx64/?.lua"
	else
		package.cpath = ";./bin/linux64/?.so"
		package.path = ";./bin/linux64/?.lua"
	end
end

ffi = require("ffi")
require("modules.console")
require("modules.string")
require("lfs")
require("enet")
require("gui")

-- Game
game = {}
require("game.constants")
require("game.commands")
require("game.config")
require("game.language")
require("game.wrapper")

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
for i = 1, 50 do
	game.Listbox:AddItem("test item "..i)
end
game.Combobox = gui.CreateCombobox(10, 310, 200, 20, game.Window)
for i = 1, 5 do
	game.Combobox:AddItem("test item "..i)
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


function love.load()
	commands.load()
	language.load()
end

function love.draw()
	game.Desktop:Render(love.timer.getDelta() * 1000)
end

function love.update(dt)
	game.Desktop:Update(dt * 1000)
end

function love.mousepressed(x, y, button)
	game.Desktop:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	game.Desktop:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
	game.Desktop:mousemoved(x, y, dx, dy)
end

function love.keypressed(key, unicode)
	game.Desktop:keypressed(key)
end

function love.keyreleased(key)
end

function love.textinput(text)
	game.Desktop:textinput(text)
end
