local Function = Core.LuaState.Function
local GUI = {}

Function.GUI = GUI

function GUI.GetDesktop(L)
	lua.lua_pushgadget(L, Interface.Gameplay.Canvas)
	return 1
end