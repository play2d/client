local Function = Core.LuaState.Function
local Hook = {}

Function.Hook = Hook

function Hook.Create(L)
	local Type = ffi.string(lua.luaL_checkstring(L, 1))
	local Identifier = ffi.string(lua.luaL_checkstring(L, 2))
	local Ref
	
	if lua.lua_isfunction(L, 3) then
		lua.lua_pushvalue(L, 3)
		Ref = lua.luaL_ref(L, lua.LUA_REGISTRYINDEX)
	else
		lua.lua_pushboolean(L, false)
		lua.lua_pushstring(L, "#3, expected function")
		return 2
	end

	local HookArray = Core.LuaState.Hooks[Type]
	if HookArray then
		if #Identifier > 0 then
			HookArray[Identifier] = Ref
			
			lua.lua_pushboolean(L, true)
			return 1
		end
	end
	
	lua.lua_pushboolean(L, false)
	lua.lua_pushstring(L, "Hook type does not exist")
	return 2
end

function Hook.Remove(L)
	local Type = ffi.string(lua.luaL_checkstring(L, 1))
	local Identifier = ffi.string(lua.luaL_checkstring(L, 2))
	
	local HookArray = Core.LuaState.Hooks[Type]
	if HookArray then
		local Ref = HookArray[Identifier]
		if Ref then
			lua.luaL_unref(L, Ref)
			HookArray[Identifier] = nil
		end
		
		lua.lua_pushboolean(L, true)
		return 1
	end
	
	lua.lua_pushboolean(L, false)
	lua.lua_pushstring(L, "Hook type does not exist")
	return 2
end