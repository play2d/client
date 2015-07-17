Hook = {}
Hook.Data = {}

--{{{ Callbacks
Hook.Data.draw = {}
--Hook.Data.errhand = {}				-- I disabled this so we can see errors while developing
Hook.Data.focus = {}
Hook.Data.gamepadaxis = {}
Hook.Data.gamepadpressed = {}
Hook.Data.gamepadreleased = {}
Hook.Data.joystickadded = {}
Hook.Data.joystickaxis = {}
Hook.Data.joystickhat = {}
Hook.Data.joystickpressed = {}
Hook.Data.joystickreleased = {}
Hook.Data.joystickremoved = {}
Hook.Data.keypressed = {}
Hook.Data.keyreleased = {}
Hook.Data.load = {}
Hook.Data.mousefocus = {}
Hook.Data.mousemoved = {}
Hook.Data.mousepressed = {}
Hook.Data.mousereleased = {}
Hook.Data.quit = {}
Hook.Data.resize = {}
Hook.Data.textinput = {}
Hook.Data.threaderror = {}
Hook.Data.touchmoved = {}
Hook.Data.touchpressed = {}
Hook.Data.touchreleased = {}
Hook.Data.update = {}
Hook.Data.visible = {}
Hook.Data.wheelmoved = {}

for Callback, Functions in pairs(Hook.Data) do
	_G.love[Callback] = function(...)
		for Index, Function in pairs(Functions) do
			Function(...)
		end
	end
end
-- }}}

function Hook.Create(Callback)
	if Hook.Data[Callback] then
		return false, "Hook '" .. Callback .. "' already exists"
	end
	Hook.Data[Callback] = {}
	return true
end

function Hook.Delete(Callback)
	if not Hook.Data[Callback] then
		return false, "Hook '" .. Callback .. "' does not exist"
	end
	Hook.Data[Callback] = nil
	return true
end

function Hook.Add(Callback, Func)
	if not Hook.Data[Callback] then
		return false, "Hook '" .. Callback .. "' does not exist"
	end
	table.insert(Hook.Data[Callback], Func)
	return Func
end

function Hook.Remove(Callback, Func)
	if not Hook.Data[Callback] then
		return false, "Hook '" .. Callback .. "' does not exist"
	end
	for Index, Function in pairs(Hook.Data[Callback]) do
		if Function == Func then
			Hook.Data[Callback][Index] = nil
		end
	end
	return true
end

function Hook.Call(Callback, ...)
	if not Hook.Data[Callback] then
		return false, "Hook '" .. Callback .. "' does not exist"
	end
	for Index, Function in pairs(Hook.Data[Callback]) do
		Function(...)
	end
	return true
end
