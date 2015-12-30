local ClassMT = Core.LuaState.ClassMT
local Entity = {}

ClassMT.Entity = Entity

function lua.lua_pushentity(L, E)
	lua.lua_pushlightuserdata(L, E)
	lua.lua_getfield(L, lua.LUA_REGISTRYINDEX, "ent_"..E:GetClass())
	if lua.lua_istable(L, -1) then
		lua.lua_setmetatable(L, -2)
	end
end

function lua.lua_toentity(L, idx)
	if lua.lua_islightuserdata(L, 1) then
		local Pointer = lua.lua_touserdata(L, idx)
		if Pointer == ffi.NULL then
			return nil
		end

		local Ent = ffi.cast("struct Entity *", Pointer)
		if Ent == ffi.NULL then
			return nil
		end
		
		if Ent:IsValid() then
			return Ent
		end
	end
end

function Entity.Initialize(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		Ent:Initialize(unpack(lua.lua_toarguments(L, 2)))
	end
	
	return 0
end

function Entity.InitializePhysics(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		Ent:InitializePhysics()
	end
	
	return 0
end

function Entity.CreateRectangleShape(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		Ent:CreateRectangleShape(unpack(lua.lua_toarguments(L, 2)))
	end
	
	return 0
end

function Entity.CreateCircleShape(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		Ent:CreateCircleShape(unpack(lua.lua_toarguments(L, 2)))
	end
	
	return 0
end

function Entity.IsValid(L)
	lua.lua_pushboolean(L, lua.lua_toentity(L, 1) ~= nil)
	return 1
end	

function Entity.GetClass(L)
	local Ent = lua.lua_toentity(L, 1)

	if Ent then
		lua.lua_pushstring(L, Ent:GetClass())
		return 1
	end
	
	return 0
end

function Entity.SetName(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		Ent:SetName(ffi.string(lua.luaL_checkstring(L, 2)))
	end
	
	return 0
end

function Entity.GetName(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		lua.lua_pushstring(L, Ent:GetName())
		return 1
	end
	
	return 0
end

function Entity.SetPosition(L)
	local Ent = lua.lua_toentity(L, 1)
	local x = tonumber(lua.luaL_checkinteger(L, 2))
	local y = tonumber(lua.luaL_checkinteger(L, 2))
	
	if Ent and x and y then
		Ent:SetPosition(x, y)
	end
	
	return 0
end

function Entity.GetPosition(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		local x, y = Ent:GetPosition()
		lua.lua_pushnumber(L, x)
		lua.lua_pushnumber(L, y)
		return 2
	end
	
	return 0
end

function Entity.SetHealth(L)
	local Ent = lua.lua_toentity(L, 1)
	local Health = tonumber(lua.luaL_checkinteger(L, 2))
	
	if Ent and Health then
		Ent:SetHealth(Health)
	end
	
	return 0
end

function Entity.GetHealth(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		lua.lua_pushinteger(L, Ent:GetHealth())
		return 1
	end
	
	return 0
end

function Entity.GetTable(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		lua.lua_rawgeti(L, lua.LUA_REGISTRYINDEX, Ent.TableRef)
		return 1
	end
	
	return 0
end

function Entity.SetTable(L)
	local Ent = lua.lua_toentity(L, 1)
	
	if Ent then
		if lua.lua_istable(L, 2) then
			lua.luaL_unref(L, self.TableRef)
			lua.lua_pushvalue(L, 2)
			
			self.TableRef = lua.luaL_ref(L, lua.LUA_REGISTRYINDEX)
			
			lua.lua_pushvalue(L, 2)
			return 1
		end
	end
	
	lua.lua_pushboolean(L, false)
	return 1
end

function Entity.Update(L)
	return 0
end

function Entity.NextUpdate(L)
	local Ent = lua.lua_toentity(L, 1)
	local Delay = tonumber(lua.luaL_checkinteger(L, 2))
	
	if Ent and Delay then
		Ent:NextUpdate(Delay)
	end
	
	return 0
end