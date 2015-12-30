local Transfer = Core.Transfer
local Network = Core.Network
local State = Core.State
local LuaState = Core.LuaState

Transfer.Stage[CONST.NET.STAGE.AWAIT] = function (Peer, Message)
	local PlayerID, Message = Message:ReadInt()
	local PlayerName, Message = Message:ReadLine()
	local GameMode, Message = Message:ReadLine()
	local MapName, Message = Message:ReadLine()
	
	local Map, Error = Core.Maps.Load(MapName)
	if Map then
		State.Map = Map
	else
		return print("Failed to load map: "..Error)
	end

	State.Renew()
	State.Mode = GameMode
	
	LuaState.Renew()
	LuaState.Load()
	
	local PlayersConnected = State.PlayersConnected
	for ID, Player in pairs(Transfer.Players) do
		PlayersConnected[ID] = {
			Code = Player.Code,
			IP = Player.IP,
			MicPort = Player.MicPort,
			MicPeer = Network.Host:connect(Player.IP..":"..Player.MicPort),
			Name = Player.Name,
			ID = ID,
			
			Score = Player.Score,
			Kills = Player.Kills,
			Deaths = Player.Deaths,
		}
	end; Transfer.Players = nil
	
	for ID, Entity in pairs(Transfer.Entities) do
		State.CreateEntity(Entity.Class, ID, Entity.x, Entity.y, Entity.Angle)
			:SetNETData(Entity.Data)
	end; Transfer.Entities = nil

	-- Process packet queue
	Interface.Connecting.Menu:Hide()
	
	local Datagram = ("")
		:WriteShort(CONST.NET.SERVERTRANSFER)
		:WriteByte(CONST.NET.STAGE.JOIN)
	
	Peer:send(Datagram, CONST.NET.CHANNELS.CONNECTING, "reliable")
end