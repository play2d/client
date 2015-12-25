local State = Core.State
local LuaState = Core.LuaState

function LuaState.Renew()
	if LuaState.State then
		lua.lua_close(LuaState.State)
	end
	
	LuaState.State = lua.luaL_newstate()
	lua.luaL_openlibs(LuaState.State)
	
	LuaState.BodyReference = {}
	LuaState.Hooks = {}

	LuaState.RegisterFunctions()
	LuaState.RegisterMetatables()
end

function LuaState.Load()
	local L = LuaState.State

--[[
	print("Loading core entities")
	for k, File in pairs(love.filesystem.getDirectoryItems("src/entities")) do
		local Name = File:match("(.+)%plua")
		if #Name > 0 then
			local Path = "src/entities/"..File
			local File = love.filesystem.newFile(Path, "r")
			
			lua.lua_newtable(L)
			lua.lua_setglobal(L, "ENTITY")
			
			if lua.luaL_dostring(L, File:read(File:getSize())) == 0 then
				local BaseClass
				
				lua.lua_getglobal(L, "ENTITY")
				if lua.lua_istable(L, -1) then
					lua.lua_getfield(L, -1, "BASE_CLASS")
					if lua.lua_isstring(L, -1) == 1 then
						BaseClass = lua.lua_tostring(L, -1)
						lua.lua_pop(L, 1)
					end
					lua.lua_pop(L, 1)
					
					lua.lua_newtable(L)
					lua.lua_pushvalue(L, -2)
					lua.lua_setfield(L, -2, "__index")
					lua.lua_setfield(L, lua.LUA_REGISTRYINDEX, "ent_"..Name)
				end
				
				if BaseClass then
					print("Entity '"..Name.."' loaded, inherits from '"..ffi.string(BaseClass).."'")
				else
					print("Entity '"..Name.."' loaded")
				end
				
				table.insert(State.Transfer, Path)
			else
				print("Lua Error: "..lua.lua_geterror(L))
			end
			File:close()
		end
	end
	
	for _, Addon in pairs(State.Addons.List) do
		print("------------------------------------------------------")
		for _, Path in pairs(Addon.Autorun.SV) do
			if lua.luaL_dofile(L, Path) ~= 0 then
				print("Lua Error: "..lua.lua_geterror(L))
			end
		end
		
		for _, Path in pairs(Addon.Autorun.SH) do
			if lua.luaL_dofile(L, Path) then
				print("Lua Error: "..lua.lua_geterror(L))
			end
		end
		
		for _, Path in pairs(Addon.Entities) do
			
			local Name = Path:match("([%w|%_|%d]+)%.lua")
			if #Name > 0 then
				
				lua.lua_newtable(L)
				lua.lua_setglobal(L, "ENTITY")
				
				if lua.luaL_dofile(L, Path) == 0 then
					local BaseClass
					
					lua.lua_getglobal(L, "ENTITY")
					if lua.lua_istable(L, -1) then
						lua.lua_getfield(L, -1, "BASE_CLASS")
						if lua.lua_isstring(L, -1) == 1 then
							BaseClass = lua.lua_tostring(L, -1)
							lua.lua_pop(L, 1)
						end
						lua.lua_pop(L, 1)
						
						lua.lua_newtable(L)
						lua.lua_pushvalue(L, -2)
						lua.lua_setfield(L, -2, "__index")
						lua.lua_setfield(L, lua.LUA_REGISTRYINDEX, "ent_"..Name)
					end
					
					if BaseClass then
						print("Entity '"..Name.."' loaded, inherits from '"..ffi.string(BaseClass).."'")
					else
						print("Entity '"..Name.."' loaded")
					end
					
					table.insert(State.Transfer, Path)
				else
					print("Lua Error: "..lua.lua_geterror(L))
				end
			end
		end
	end
]]

	lua.lua_pushvalue(L, lua.LUA_REGISTRYINDEX)
	lua.lua_pushnil(L)

	while lua.lua_next(L, -2) ~= 0 do
		lua.lua_pushvalue(L, -2)
		
		local Key = ffi.string(lua.lua_tostring(L, -1))
		
		if Key:sub(1, 4) == "ent_" then
			local BaseClass = "Entity"
			
			lua.lua_getfield(L, lua.LUA_REGISTRYINDEX, Key)
			lua.lua_getfield(L, -1, "__index")

			lua.lua_getfield(L, -1, "BASE_CLASS")
			if lua.lua_isstring(L, -1) then
				local Class = ffi.string(lua.lua_tostring(L, -1))
				if #Class > 0 then
					BaseClass = "ent_"..Class
				end
			end
			lua.lua_pop(L, 1)
			
			lua.lua_getfield(L, lua.LUA_REGISTRYINDEX, BaseClass)
			lua.lua_setmetatable(L, -2)
			lua.lua_pop(L, 2)
		end
		
		lua.lua_pop(L, 2)
	end
	lua.lua_pop(L, 1)

	print("Game mode: "..State.Mode)
end