local Transfer = Core.Transfer

Transfer.Stage[CONST.NET.STAGE.GETSTATEENTS] = function (Peer, Message)
	if Core.Transfer.File then
		Core.Transfer.File:close()
		Core.Transfer.File = nil
		Core.Transfer.FilePath = nil
		Core.Transfer.FileSize = nil
	end
	
	local EntityCount, Message = Message:ReadInt24()
	
	if EntityCount > 0 then
		local EntityID, Message = Message:ReadInt24()
		local EntityClass, Message = Message:ReadLine()
		local EntityX, Message = Message:ReadInt()
		local EntityY, Message = Message:ReadInt()
		local EntityAngle, Message = Message:ReadShort()
		local DataSize, Message = Message:ReadInt24()
		local Data, Message = Message:ReadString(DataSize)
		
		local EntityMemory = {
			ID = EntityID,
			Class = EntityClass,
			x = EntityX,
			y = EntityY,
			Angle = EntityAngle - 360,
			Data = {},
		}
		
		if #Data > 0 then
			local Success, Decode = pcall(json.decode, Data)
			if Success then
				EntityMemory.Decode = Data
			end
		end
		
		table.insert(Transfer.Entities, EntityMemory)
	end
end