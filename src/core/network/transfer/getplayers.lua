local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.GETSTATEPLYS] = function (Peer, Message)
	local PlayerCount, Message = Message:ReadByte()
	
	if PlayerCount > 0 then
		local PlayerID, Message = Message:ReadByte()
		local PlayerCode, Message = Message:ReadLine()
		local PlayerName, Message = Message:ReadLine()
		local PlayerScore, Message = Message:ReadNumber()
		local PlayerKills, Message = Message:ReadNumber()
		local PlayerDeaths, Message = Message:ReadNumber()
		
		State.PlayersConnected[PlayerID] = {
			Name = PlayerName,
			Score = PlayerScore,
			Kills = PlayerKills,
			Deaths = PlayerDeaths,
		}
		
		local Progress = math.floor((table.count(State.PlayersConnected)/PlayerCount)*100)
		Interface.Connecting.Transfer.ProgressBar.Progress = Progress
		Interface.Connecting.Transfer.Label:SetText(Lang.Get2("gui_connecting_players"))
	end
end