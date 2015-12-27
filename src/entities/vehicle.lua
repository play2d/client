function ENTITY:Initialize()
	self:GetTable().Passenger = {
		{x = 0, y = 0},
	}
end

function ENTITY:IsVehicle()
	return true
end

function ENTITY:IsUsable()
	return true
end

function ENTITY:GetDriver()
	return self:GetTable().Driver
end

function ENTITY:SetDriver(Entity)
	self:GetTable().Driver = Entity
end

function ENTITY:OnUse(Entity)
	local Driver = self:GetDriver()
	if Driver == Entity then
		self:SetDriver(nil)
	elseif Driver == nil or not Driver:IsValid() then
		self:SetDriver(Entity)
	end
end

function ENTITY:GetPassenger(Index)
	local Table = self:GetTable()
	local Passenger = Table.Passenger[Index]
	if Passenger then
		return Passenger.Entity
	end
end

function ENTITY:SetPassenger(Index, Entity)
	local Table = self:GetTable()
	local Passenger = Table.Passenger[Index]
	if Passenger then
		Passenger.Entity = Entity
	end
end