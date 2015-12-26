local Transfer = Core.Transfer

Transfer.Stage = {}

Core.Network.Protocol[CONST.NET.SERVERTRANSFER] = function (Peer, Message)
	if Peer == Core.Connect.Request then
		local Stage, Message = Message:ReadByte()
		local Function = Transfer.Stage[Stage]

		if Function then
			Function(Peer, Message)
		end
	end
end