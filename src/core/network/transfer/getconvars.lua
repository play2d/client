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
		
		local Progress = math.floor((table.count(Core.State.ConVars)/CVarCount)*100)
		Interface.Connecting.Transfer.ProgressBar.Progress = Progress
		Interface.Connecting.Transfer.Label:SetText(Lang.Get2("gui_connecting_cvars"))
	end
end