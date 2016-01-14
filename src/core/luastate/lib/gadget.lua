local State = Core.State
local ClassMT = Core.LuaState.ClassMT
local TGadget = {}

ClassMT.Gadget = TGadget

function lua.lua_pushgadget(L, Gadget)
	local Address = tostring(Gadget):match("table: (.+)")
	local intAddress = tonumber(Address, 16)
	
	if intAddress then
		local CData
		if State.GadgetReference[intAddress] then
			CData = State.GadgetReference[intAddress]
		else
			CData = ffi.new("struct Gadget", {Address = intAddress})
			State.GadgetReference[intAddress] = CData
		end
		State.InterfaceReference[intAddress] = Gadget
		
		lua.lua_pushlightuserdata(L, CData)
		lua.lua_getfield(L, lua.LUA_REGISTRYINDEX, "Gadget")
		if lua.lua_istable(L, -1) then
			lua.lua_setmetatable(L, -2)
		end
	end
end

function lua.lua_togadget(L, idx)
	if lua.lua_islightuserdata(L, 1) then
		local VoidPtr = lua.lua_tolightuserdata(L, 1)
		if VoidPtr == nil then
			return nil
		end
		
		local Cast = ffi.cast("Gadget *", VoidPtr)
		if Cast == nil then
			return nil
		end
		
		local intAddress = tonumber(Cast.Address)
		if intAddress then
			return State.InterfaceReference[intAddress], intAddress
		end
	end
end

function TGadget:Remove()
	local Gadget, intAddress = lua.lua_togadget(L, 1)
	if Gadget then
		Gadget:Remove()
		State.InterfaceReference[intAddress] = nil
		State.BodyReference[intAddress] = nil
	end
end