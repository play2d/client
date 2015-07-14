hook = {}
hook.Data = {}

--{{{ Callbacks
hook.Data.draw = {}
hook.Data.errhand = {}
hook.Data.focus = {}
hook.Data.gamepadaxis = {}
hook.Data.gamepadpressed = {}
hook.Data.gamepadreleased = {}
hook.Data.joystickadded = {}
hook.Data.joystickaxis = {}
hook.Data.joystickhat = {}
hook.Data.joystickpressed = {}
hook.Data.joystickreleased = {}
hook.Data.joystickremoved = {}
hook.Data.keypressed = {}
hook.Data.keyreleased = {}
hook.Data.load = {}
hook.Data.mousefocus = {}
hook.Data.mousemoved = {}
hook.Data.mousepressed = {}
hook.Data.mousereleased = {}
hook.Data.quit = {}
hook.Data.resize = {}
hook.Data.textinput = {}
hook.Data.threaderror = {}
hook.Data.touchmoved = {}
hook.Data.touchpressed = {}
hook.Data.touchreleased = {}
hook.Data.update = {}
hook.Data.visible = {}
hook.Data.wheelmoved = {}

for callback,funcs in pairs(hook.Data) do
	_G.love[callback] = function(...)
		for func,_ in pairs(funcs) do
			func(unpack({...}))
		end
	end
end
-- }}}

function hook.Add(Callback, Func)
	if not hook.Data[Callback] then
		error("Unknown callback: " .. callback)
	end

	hook.Data[Callback][Func] = true

	return Func
end

function hook.Remove(Callback, Func)
	if not hook.Data[Callback] then
		error("Unknown callback: " .. callback)
	end

	if hook.Data[Callback][Func] then
		table.remove(hook.Data[Callback], Func)
	end
end
