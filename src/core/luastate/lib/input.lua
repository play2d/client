local Function = Core.LuaState.Function
local Input = {}

Function.Input = Input

function Input.KeyDown(L)
	local Key = lua.luaL_checkstring(L, 1)
	local KeyString = ffi.string(Key)
	
	if #KeyString > 0 then
		lua.lua_pushboolean(L, love.keyboard.isDown(KeyString))
		return 1
	end
	
	return 0
end

function Input.ScancodeDown(L)
	local Scancode = lua.luaL_checkstring(L, 1)
	local ScancodeString = ffi.string(Scancode)
	
	if #ScancodeString > 0 then
		lua.lua_pushboolean(L, love.keyboard.isScancodeDown(ScancodeString))
		return 1
	end
	
	return 0
end

function Input.MouseDown(L)
	local Button = lua.luaL_checkinteger(L, 1)
	local ButtonNumber = tonumber(Button)
	
	if ButtonNumber then
		lua.lua_pushboolean(L, love.mouse.isDown(ButtonNumber))
		return 1
	end
	
	return 0
end

function Input.MouseX(L)
	lua.lua_pushinteger(L, love.mouse.getX())
	return 1
end

function Input.MouseY(L)
	lua.lua_pushinteger(L, love.mouse.getY())
	return 1
end

function Input.MousePosition(L)
	local x, y = love.mouse.getPosition()
	lua.lua_pushinteger(L, x)
	lua.lua_pushinteger(L, y)
	return 2
end
