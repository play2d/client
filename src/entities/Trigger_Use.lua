DEFINE_BASECLASS("CS2DENTITY")

function ENTITY:Initialize(Entity)
end

function ENTITY:Trigger()
	self.EntState = not self.EntState
end

function ENTITY:OnUse(Source)
	self.Base.Trigger(self)
end

if SERVER then
	function ENTITY:GetNETData()
		return {EntState = self.EntState}
	end
end

if CLIENT then
	function ENTITY:SetNETData(Data)
		self.EntState = Data.EntState
	end
end