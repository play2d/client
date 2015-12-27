DEFINE_BASECLASS("CS2DENTITY")

function ENTITY:Initialize(Entity)
	self:SetPosition(Entity.Position.x * 32 + 16, Entity.Position.y * 32 + 16)
end