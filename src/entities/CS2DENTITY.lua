function ENTITY:Initialize(Entity)
	local Table = self:GetTable()
	Table.Name = Name
	Table.Triggers = Triggers
	Table.State = true
end

function ENTITY:Trigger()
	for Entity in Entities.EachEntity() do
		local Table = Entities:GetTable()
		
		if Table.EntName then
			if table.find(Table.EntTriggers, Table.EntName) then
				Entity:Trigger()
			end
		end
	end
end