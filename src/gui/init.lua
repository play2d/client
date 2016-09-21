local Path = (...):gsub("%p", "/")
local gui = {}

gui.Path = Path
gui.Skin = Path.."/skins/cyan/"
gui.Elements = {}
gui.Fonts = {}
gui.Mobile = love.system.getOS() == "Android" or love.system.getOS() == "iOS"
gui.LoadQueue = {}

assert(love.filesystem.load(Path.."/fonts/init.lua"))(Path.."/fonts/", gui)
assert(love.filesystem.load(Path.."/string.lua"))(Path, gui)
assert(love.filesystem.load(Path.."/text.lua"))(Path, gui)
assert(love.filesystem.load(Path.."/stencil.lua"))(Path, gui)

function gui.create(Name, ...)
	
	local Class = gui.Elements[Name]
	
	if Class then
		
		return setmetatable({}, Class.Metatable):Create(...)
		
	end
	
	return nil, "Element type not found"
	
end

function gui.get(Name)
	
	if not gui.Elements[Name] then
		
		local Coroutine = coroutine.running()
		
		if Coroutine then
		
			table.insert(gui.LoadQueue, Coroutine)
			
			coroutine.yield()
			
		end
		
	end
	
	return gui.Elements[Name]
	
end

function gui.register(Name, BaseClass)
	
	if gui.Elements[Name] then
		
		return gui.Elements[Name]
		
	end
	
	local Element = {}
	Element.Type = Name
	Element.Metatable = {__index = Element}
	
	if BaseClass then
		
		local Class = gui.Elements[BaseClass]
		
		if not Class then
			
			local Coroutine = coroutine.running()
			
			if Coroutine then
				
				table.insert(gui.LoadQueue, Coroutine)
			
				coroutine.yield()
				
				Class = gui.Elements[BaseClass]
				
			end
			
		end
		
		if Class then
			
			Element.Base = Class
			setmetatable(Element, Class.Metatable)
			
		else
			
			return nil, 'Element "'..BaseClass..'" not found for "'..Name..'"'
			
		end
		
	end
	
	gui.Elements[Name] = Element
	
	return Element
	
end

function gui.load()
	
	gui.Desktop = gui.create("Desktop", love.graphics.getCanvas())
	gui.Desktop.Skin = assert(love.filesystem.load(gui.Skin.."init.lua"))(gui.Skin, gui)
	
	gui.load = nil
	
end

function gui.draw(dt)
	
	gui.Desktop:Render(dt, 0, 0)
	
end

function gui.update(dt)
	
	gui.Desktop:Update(dt)
	
end

function gui.mousepressed(x, y, Button, IsTouch)
	
	gui.Desktop:MousePressed(x, y, Button, IsTouch)
	
end

function gui.mousereleased(x, y, Button, IsTouch)
	
	gui.Desktop:MouseReleased(x, y, Button, IsTouch)
	
end

function gui.mousemoved(x, y, dx, dy)
	
	gui.Desktop:MouseMoved(x, y, dx, dy)
	
end

function gui.wheelmoved(x, y)
	
	gui.Desktop:WheelMoved(x, y)
	
end

function gui.keypressed(Key, ScanCode, IsRepeat)
	
	gui.Desktop:KeyPressed(Key, ScanCode, IsRepeat)
	
end

function gui.textinput(Text)
	
	gui.Desktop:TextInput(Text)
	
end

love.filesystem.load(Path.."/elements/init.lua")(Path.."/elements/", gui)

return gui