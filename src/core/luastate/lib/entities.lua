local Function = Core.LuaState.Function
local Entities = {}

Function.Entities = Entities

function Entities.CreateEntity(L)
	local Class = ffi.string(lua.luaL_checkstring(L, 1))
	local EntityID = tonumber(lua.luaL_checkinteger(L, 2))
	local x = tonumber(lua.luaL_checkinteger(L, 3))
	local y = tonumber(lua.luaL_checkinteger(L, 4))
	local Angle = tonumber(lua.luaL_checkinteger(L, 5))
	local Arguments = lua.lua_toarguments(L, 6)
	
	if #Class > 0 then
		local Entity = State.CreateEntity(Class, x, y, Angle, unpack(Arguments))
		if Entity then
			lua.lua_pushentity(L, Entity)
			return 1
		end
	end
	
	return 0
end

function Entities.FindByID(L)
	local ID = tonumber(lua.luaL_checkinteger(L, 1))
	
	if ID then
		local Entity = Core.State.Entities[ID]
		if Entity then
			lua.lua_pushentity(L, Entity)
			return 1
		end
	end
	return 0
end

function Entities.FindByClass(L)
	local Class = ffi.string(lua.luaL_checkstring(L, 1))
	local Entities = {}
	
	for _, Entity in pairs(Core.State.Entities) do
		if Entity:GetClass():find(Class) then
			table.insert(Entities, Entity)
		end
	end
	
	lua.lua_pushrawtable(L, Entities)
	return 1
end

function Entities.FindByName(L)
	local Name = ffi.string(lua.luaL_checkstring(L, 1))
	local Entities = {}
	
	for _, Entity in pairs(Core.State.Entities) do
		if Entity:GetName():find(Name) then
			table.insert(Entities, Entity)
		end
	end
	
	lua.lua_pushrawtable(L, Entities)
	return 1
end

function Entities.FindByAddress(L)
	local Address = ffi.string(lua.luaL_checkstring(L, 1))
	local Entities = {}
	
	for _, Entity in pairs(Core.State.Entities) do
		if Entity:GetAddress():find(Address) then
			table.insert(Entities, Entity)
		end
	end
	
	lua.lua_pushrawtable(L, Entities)
	return 1
end

function Entities.GetAll(L)
	lua.lua_pushrawtable(L, Core.State.Entities)
	return 1
end