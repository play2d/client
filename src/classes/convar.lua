ffi.cdef [[
	typedef struct ConVar {
		bool Save;
		bool SendToClient;
		
		char * Name;
		char * Value;
	};
]]

local ConVar = {}
local ConVarMT = {__index = ConVar}

ffi.metatype("struct ConVar", ConVarMT)

function ConVar:GetName()
	return ffi.string(self.Name)
end

function ConVar:GetInt()
	if self.Value ~= ffi.NULL then
		return math.floor(tonumber(ffi.string(self.Value))) or 0
	end
	return 0
end

function ConVar:GetNumber()
	if self.Value ~= ffi.NULL then
		return math.floor(tonumber(ffi.string(self.Value))) or 0
	end
	return 0
end

function ConVar:GetString()
	if self.Value ~= ffi.NULL then
		return ffi.string(self.Value)
	end
	return ""
end

if CLIENT then
	
	function ConVar:Set(v)
		local StringValue
		if v == nil then
			StringValue = ""
		else
			StringValue = tostring(v)
		end
		self.Value = StringValue
	end
	
elseif SERVER then
	
	function ConVar:Set(v)
		local StringValue
		if v == nil then
			StringValue = ""
		else
			StringValue = tostring(v)
		end
		self.Value = StringValue
		
		local Datagram = ("")
			:WriteShort(CONST.NET.CVAR)
			:WriteLine(ffi.string(self.Name))
			:WriteShort(#StringValue)
			:WriteString(StringValue)
		
		for Address, Connection in pairs(Core.State.PlayersConnected) do
			Connection.Peer:send(Datagram)
		end
		
		for Address, Connection in pairs(Core.State.PlayersConnecting) do
			Connection.Peer:send(Datagram)
		end
	end
	
end

function ConVar:SetInt(n)
	if type(n) == "number" then
		self:Set(math.floor(n))
	else
		self:Set(0)
	end
end

function ConVar:SetNumber(n)
	if type(n) == "number" then
		self:Set(n)
	else
		self:Set(0)
	end
end

function ConVar:SetString(Str)
	if type(Str) == "string" then
		self:Set(Str)
	else
		self:Set("")
	end
end

function ConVar:Delete()
	local Name = ffi.string(self.Name)
	if #Name > 0 then
		Core.State.ConVars[Name] = nil
	end
end