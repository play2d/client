local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.GETSTATEPLYS] = function (Peer, Message)
	local PlayerCount, Message = Message:ReadByte()
	
	if PlayerCount > 0 then
		local PlayerID, Message = Message:ReadInt()
		local PlayerCode, Message = Message:ReadLine()
		local PlayerName, Message = Message:ReadLine()
		local PlayerIP, Message = Message:ReadLine()
		local PlayerMicPort, Message = Message:ReadShort()
		local PlayerScore, Message = Message:ReadNumber()
		local PlayerKills, Message = Message:ReadNumber()
		local PlayerDeaths, Message = Message:ReadNumber()
		
		Transfer.Players[PlayerID] = {
			Code = PlayerCode,
			Name = PlayerName,
			IP = PlayerIP,
			MicPort = PlayerMicPort,
			Score = PlayerScore,
			Kills = PlayerKills,
			Deaths = PlayerDeaths,
		}
		
		local Progress = math.floor((table.count(State.PlayersConnected)/PlayerCount)*100)
		Interface.Connecting.Transfer.ProgressBar.Progress = Progress
		Interface.Connecting.Transfer.Label:SetText(Lang.Get2("gui_connecting_players"))
	end
end