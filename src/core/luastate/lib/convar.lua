local ClassMT = Core.LuaState.ClassMT
local ConVar = {}

ClassMT.ConVar = ConVar

function lua.lua_pushcvar(L, E)
	lua.lua_pushlightuserdata(L, E)
	lua.lua_getfield(L, lua.LUA_REGISTRYINDEX, "ConVar")
	if lua.lua_istable(L, -1) then
		lua.lua_setmetatable(L, -2)
	end
end

function lua.lua_tocvar(L, idx)
	if lua.lua_islightuserdata(L, 1) then
		local Pointer = lua.lua_touserdata(L, idx)
		if Pointer == ffi.NULL then
			return nil
		end

		local CVar = ffi.cast("struct ConVar *", Pointer)
		if CVar == ffi.NULL then
			return nil
		end

		return CVar
	end
end

function ConVar.GetInt(L)
	local CVar = lua.lua_tocvar(L, 1)
	
	if CVar then
		lua.lua_pushinteger(L, CVar:GetInt())
		return 1
	end
	
	return 0
end

function ConVar.GetNumber(L)
	local CVar = lua.lua_tocvar(L, 1)
	
	if CVar then
		lua.lua_pushnumber(L, CVar:GetNumber())
		return 1
	end
	
	return 0
end

function ConVar.GetString(L)
	local CVar = lua.lua_tocvar(L, 1)
	
	if CVar then
		lua.lua_pushstring(L, CVar:GetString())
		return 1
	end
	
	return 0
end

function ConVar.SetInt(L)
	local CVar = lua.lua_tocvar(L, 1)
	
	if CVar then
		CVar:SetInt(tonumber(lua.luaL_checkinteger(L, 2)))
	end
	
	return 0
end

function ConVar.SetNumber(L)
	local CVar = lua.lua_tocvar(L, 1)
	
	if CVar then
		CVar:SetNumber(tonumber(lua.lua_tonumber(L, 2)))
	end
	
	return 0
end

function ConVar.SetString(L)
	local CVar = lua.lua_tocvar(L, 1)
	
	if CVar then
		CVar:SetString(ffi.string(lua.luaL_checkstring(L, 2)))
	end
	
	return 0
end

function ConVar.Delete(L)
	local CVar = lua.lua_tocvar(L, 1)
	
	if CVar then
		CVar:Delete()
	end
	
	return 0
end