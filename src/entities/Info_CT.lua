DEFINE_BASECLASS("CS2DENTITY")

if SERVER then

	function ENTITY:Initialize(Entity)
		self:SetPosition(Entity.Position.x * 32 + 16, Entity.Position.y * 32 + 16)
		
		local Table = self:GetTable()
		Table.EntityReference = Entity
	end
	
	function ENTITY:GetNETData()
		local Table = self:GetTable()
		local Entity = Table.EntityReference
		
		return {
			x = Entity.Position.x,
			y = Entity.Position.y,
		}
	end
	
elseif CLIENT then
	
	function ENTITY:SetNETData(Data)
		self:SetPosition(Data.x, Data.y)
	end
	
end