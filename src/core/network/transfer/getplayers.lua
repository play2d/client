local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.GETSTATEPLYS] = function (Peer, Message)
	local PlayerCount, Message = Message:ReadByte()
	
	if PlayerCount > 0 then
		local PlayerCode, Message = Message:ReadLine()
		local PlayerName, Message = Message:ReadLine()
		local PlayerScore, Message = Message:ReadNumber()
		local PlayerKills, Message = Message:ReadNumber()
		local PlayerDeaths, Message = Message:ReadNumber()
		
		State.PlayersConnected[PlayerCode] = {
			Name = PlayerName,
			Score = PlayerScore,
			Kills = PlayerKills,
			Deaths = PlayerDeaths,
		}
	end
end