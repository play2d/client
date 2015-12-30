local State = Core.State
local LuaState = Core.LuaState

function State.FindEntityClass(Class)
	return LuaState.Entity[Class]
end

function State.CreateEntity(Class, EntityID, x, y, Angle, ...)
	if type(Class) == "string" and type(x) == "number" and type(y) == "number" and type(Angle) == "number" then
		if EntityID > 16777215 then
			return nil
		end
		
		local L = LuaState.State
		lua.lua_newtable(L)
		local Ref = lua.luaL_ref(L, lua.LUA_REGISTRYINDEX)
		
		local Entity = ffi.new("struct Entity")
		Entity.Name = ""
		Entity.PtrAddress = tostring(Entity):match("cdata<struct Entity>: (.+)")
		Entity.Address = ""
		Entity.Class = Class
		Entity.Health = 0
		Entity.Armor = 0
		Entity.Angle = Angle
		Entity.x = x
		Entity.y = y
		Entity.ID = EntityID
		
		Entity.LuaStateRef = L
		Entity.TableRef = Ref

		State.Entities[EntityID] = Entity
		
		local Data = Entity:GetNETData()
		local Encoded = json.encode(Data)

		lua.lua_pushentity(L, Entity)
		lua.lua_getmetatable(L, -1)
		if lua.lua_istable(L, -1) then
			lua.lua_pop(L, 1)
			lua.lua_getfield(L, -1, "Initialize")
		
			if lua.lua_isfunction(L, -1) then
				lua.lua_pushentity(L, Entity)
				local Args = lua.lua_pushrawarguments(L, ...) + 1
				if lua.lua_pcall(L, Args, 0, 0) ~= 0 then
					print("Lua Error ["..Class.."]: "..lua.lua_geterror(L))
				end
			else
				error("No initializer function found for "..Class)
			end
		else
			error("UNREGISTERED CLASS "..Class)
		end
		
		return Entity
	else
		print("Wrong function arguments")
	end
end

function State.EachEntity()
	local Iterator = pairs(State.Entities)
	return function ()
		local Index, Entity = Iterator()
		return Entity
	end
end

function State.GetMaxPlayers()
	return Config.CFG["sv_maxplayers"]
end

function State.GetPlayersConnected()
	return table.count(State.PlayersConnecting) + table.count(State.PlayersConnected)
end

function State.GetPlayerEntity(Address)
	local Connection = State.PlayersConnected[Address]
	if Connection.EntityID then
		local Entity = State.Entities[Connection.EntityID]
		if not Entity then
			Connection.EntityID = nil
		end
		return Entity
	end
end

function State.EachPlayerEntity()
	local Entities = {}
	local Iterator = pairs(State.PlayersConnected)
	return function ()
		local Address, Connection = Iterator()
		if Address then
			return State.GetPlayerEntity(Address)
		end
	end
end