ENTITY.Health = 100
ENTITY.Team = "Neutral"

function ENTITY:Initialize(Memory)
	self:InitializePhysics()
	self:CreateCircleShape(16)
end

if SERVER then

	function ENTITY:GetNETData()
		return {
			Health = self.Health,
			Name = self.Name,
			Team = self.Team,
		}
	end
	
end

if CLIENT then
	
	function ENTITY:SetNETData(Memory)
		self.Health = Memory.Health
		self.Name = Memory.Name
		self.Team = Memory.Team
	end
	
	function ENTITY:GetHoverText()
		local Player = LocalPlayer()
		if Player then
			if self.Team == Player.Team then
				return self.Name.." - "..self.Health.."%"
			end
		end
		return self.Name
	end
	
	function ENTITY:GetHoverTextColor()
		local Player = LocalPlayer()
		if Player then
			if self.Team == Player.Team then
				return 0, 255, 0
			end
		end
		return 255, 0, 0
	end
	
end