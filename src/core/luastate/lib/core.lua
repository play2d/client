local Function = Core.LuaState.Function

function Function.parse(L)
	local Command = ffi.string(lua.luaL_checkstring(L, 1))
	if Command then
		parse(Command)
	end
	return 0
end

function Function.DEFINE_BASECLASS(L)
	local BaseClass = ffi.string(lua.luaL_checkstring(L, 1))
	
	lua.lua_getglobal(L, "ENTITY")
	if lua.lua_istable(L, -1) then
		lua.lua_pushstring(L, BaseClass)
		lua.lua_setfield(L, -2, "BASE_CLASS")
		lua.lua_pop(L, 2)
	end
	return 0
end

function Function.DEFINE_GAMEMODE(L)
	local GameMode = ffi.string(lua.luaL_checkstring(L, 1))
	if #GameMode > 0 then
		State.Mode = GameMode
	end
	return 0
end