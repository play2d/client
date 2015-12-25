local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.GETSTATECVARS] = function (Peer, Message)
	local CVarCount, Message = Message:ReadByte()
	
	if CVarCount > 0 then
		local CVarName, Message = Message:ReadLine()
		local CVarSize, Message = Message:ReadShort()
		local CVarValue, Message = Message:ReadString(CVarSize)
		
		local CVar = ffi.new("struct ConVar")
		CVar.Name = CVarName
		CVar.Value = CVarValue
		CVar.SendToClient = true
		
		Core.State.ConVars[CVarName] = CVar
	end
end