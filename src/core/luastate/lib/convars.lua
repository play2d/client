local Function = Core.LuaState.Function
local ConVar = {}

Function.ConVar = ConVar

if SERVER then
	
	function ConVar.Create(L)
		local Name = ffi.string(lua.luaL_checkstring(L, 1))
		
		if #Name > 0 then
			local ConVars = Core.State.ConVars
			local CVar = ConVars[Name]
			if not CVar then
				local CVar = ffi.new("struct ConVar")
				CVar.Name = Name
				CVar.Value = ""
				CVar.Save = false
				CVar.SendToClient = false
				
				ConVars[Name] = CVar
				
				local Datagram = ("")
					:WriteShort(CONST.NET.CVARNEW)
					:WriteLine(Name)
				
				Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.CVARS, "reliable")
			end
			
			lua.lua_pushcvar(L, CVar)
			return 1
		end
		
		return 0
	end
	
elseif CLIENT then
	
	function ConVar.Create(L)
		local Name = ffi.string(lua.luaL_checkstring(L, 1))
		
		if #Name > 0 then
			local ConVars = Core.State.ConVars
			local CVar = ConVars[Name]
			if not CVar then
				local CVar = ffi.new("struct ConVar")
				CVar.Name = Name
				CVar.Value = ""
				CVar.Save = false
				CVar.SendToClient = false
				
				ConVars[Name] = CVar
			end
			
			lua.lua_pushcvar(L, CVar)
			return 1
		end
		
		return 0
	end
	
end

function ConVar.Find(L)
	local Name = ffi.string(lua.luaL_checkstring(L, 1))
	
	if #Name > 0 then
		local CVar = Core.State.ConVars[Name]
		if CVar then
			lua.lua_pushcvar(L, CVar)
			return 1
		end
	end
	
	return 0
end

function ConVar.Delete(L)
	local Name = ffi.string(lua.luaL_checkstring(L, 1))
	
	if #Name > 0 then
		local CVar = Core.State.ConVars[Name]
		if CVar then
			CVar:Delete()
		end
	end
	
	return 0
end