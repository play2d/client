Hook = {}
Hook.Data = {
	draw = {},
--	errhand = {},				-- I disabled this so we can see errors while developing
	focus = {},
	gamepadaxis = {},
	gamepadpressed = {},
	gamepadreleased = {},
	joystickadded = {},
	joystickaxis = {},
	joystickhat = {},
	joystickpressed = {},
	joystickreleased = {},
	joystickremoved = {},
	keypressed = {},
	keyreleased = {},
	mousefocus = {},
	mousemoved = {},
	mousepressed = {},
	mousereleased = {},
	quit = {},
	resize = {},
	textinput = {},
	threaderror = {},
	touchmoved = {},
	touchpressed = {},
	touchreleased = {},
	update = {},
	visible = {},
	wheelmoved = {},
}
Hook.Custom = {}

for Callback, Functions in pairs(Hook.Data) do
	_G.love[Callback] = function(...)
		for Index, Function in pairs(Functions) do
			Function(...)
		end
	end
end

function Hook.Create(Callback)
	if Hook.Data[Callback] or Hook.Custom[Callback] then
		return false, "Hook '" .. Callback .. "' already exists"
	end
	Hook.Custom[Callback] = {}
	return true
end

function Hook.Delete(Callback)
	if not Hook.Custom[Callback] then
		return false, "Hook '" .. Callback .. "' does not exist"
	end
	Hook.Custom[Callback] = nil
	return true
end

function Hook.Add(Callback, Func)
	if Hook.Data[Callback] then
		table.insert(Hook.Data[Callback], Func)
	elseif Hook.Custom[Callback] then
		table.insert(Hook.Custom[Callback], Func)
	else
		return false, "Hook '" .. Callback .. "' does not exist"
	end
	return true
end

function Hook.Remove(Callback, Func)
	if Hook.Data[Callback] then
		for Index, Function in pairs(Hook.Data[Callback]) do
			if Function == Func then
				Hook.Data[Callback][Index] = nil
			end
		end
	elseif Hook.Custom[Callback] then
		for Index, Function in pairs(Hook.Custom[Callback]) do
			if Function == Func then
				Hook.Custom[Callback][Index] = nil
			end
		end
	else
		return false, "Hook '" .. Callback .. "' does not exist"
	end
	return true
end

function Hook.Call(Callback, ...)
	if not Hook.Custom[Callback] then
		return false, "Hook '" .. Callback .. "' does not exist"
	end
	for Index, Function in pairs(Hook.Custom[Callback]) do
		Function(...)
	end
	return true
end
