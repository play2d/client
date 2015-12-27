function ENTITY:Initialize(Name, Triggers)
	self.EntName = Name
	self.EntTriggers = Triggers
	self.EntState = true
end

function ENTITY:Trigger()
	for Entity in Core.State.EachEntity() do
		if Entity.EntName then
			if table.find(self.EntTriggers, Entity.EntName) then
				Entity:Trigger()
			end
		end
	end
end