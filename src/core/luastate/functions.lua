local State = Core.LuaState
local LuaState = Core.LuaState

function LuaState.RegisterFunctions()
	local L = LuaState.State
	
	for Name, F in pairs(LuaState.Function) do
		if type(F) == "function" then
			lua.lua_register(L, Name, F)
		elseif type(F) == "table" then
			lua.lua_newtable(L)
			for Name2, F2 in pairs(F) do
				lua.lua_pushcfunction(L, F2)
				lua.lua_setfield(L, -2, Name2)
			end
			lua.lua_setglobal(L, Name)
		end
	end
end

function LuaState.RegisterMetatables()
	local L = LuaState.State

	for ClassName, Class in pairs(LuaState.ClassMT) do
		lua.lua_newtable(L)
		
		lua.lua_pushvalue(L, -1)
		lua.lua_setfield(L, -2, "__index")
		
		for Method, Value in pairs(Class) do
			if type(Value) == "function" then
				lua.lua_pushcfunction(L, Value)
				lua.lua_setfield(L, -2, Method)
			end
		end
		
		lua.lua_setfield(L, lua.LUA_REGISTRYINDEX, ClassName)
	end
end