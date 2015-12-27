DEFINE_BASECLASS("CS2DENTITY")

function ENTITY:Initialize()
	self:InitializePhysics()
	self:CreateRectangleShape(-16, -16, 32, 32)
end

function ENTITY:Trigger()
	self.EntState = not self.EntState
	self.PhysObj:setActive(self.EntState)
end

if SERVER then
	
	function ENTITY:GetNETData()
		return {EntState = self.EntState}
	end
	
end

if CLIENT then
	
	function ENTITY:SetNETData(Data)
		self.EntState = Data.EntState
		self.PhysObj:setActive(self.EntState)
	end
	
	function ENTITY:Render()
	end

end