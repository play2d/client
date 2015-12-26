local State = Core.State
local LuaState = Core.LuaState

ffi.cdef [[
	typedef struct Entity {
		const char * Name;
		const char * PtrAddress;
		const char * Address;
		const char * Class;
		double Health;
		double Armor;
		short Angle;
		double x;
		double y;
		unsigned int ID;
		
		lua_State * LuaStateRef;
		int TableRef;
		Proxy * PhysObj;
	}
]]

local Entity = {}
local Metatable = {}

Metatable.__index = Entity

function Metatable:__gc()
	self:Delete()
	
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		PhysObj:destroy()
		LuaState.BodyReference[self.PhysObj] = nil
	end
	lua.luaL_unref(self.LuaStateRef, self.TableRef)
end

ffi.metatype("struct Entity", Metatable)

function Entity:GetPhysicsObject()
	if self.PhysObj then
		return LuaState.BodyReference[self.PhysObj]
	end
end

function Entity:SetPhysicsObject(PhysObj)
	if type(PhysObj) == "Body" then
		self.PhysObj = ffi.cast("Proxy *", PhysObj)
		
		LuaState.BodyReference[self.PhysObj] = PhysObj
	end
end

function Entity:InitializePhysics()
	local PhysObj = self:GetPhysicsObject()
	if not PhysObj then
		local x, y = self:GetPosition()
		local Angle = self:GetAngle()
		
		local PhysObj = love.physics.newBody(Core.State.Map.World, x, y)
		PhysObj:setUserData {Entity = self}
		PhysObj:setAngle(Angle)
		self:SetPhysicsObject(PhysObj)
	end
end

function Entity:CreateChainShape(...)
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		local Shape = love.physics.newChainShape(true, ...)
		local Fixture = love.physics.newFixture(PhysObj, Shape)
		
		return Shape, Fixture
	end
end

function Entity:CreateCircleShape(...)
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		local Shape = love.physics.newCircleShape(...)
		local Fixture = love.physics.newFixture(PhysObj, Shape)
		
		return Shape, Fixture
	end
end

function Entity:CreateEdgeShape(...)
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		local Shape = love.physics.newEdgeShape(...)
		local Fixture = love.physics.newFixture(PhysObj, Shape)
		
		return Shape, Fixture
	end
end

function Entity:CreatePolygonShape(...)
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		local Shape = love.physics.newPolygonShape(...)
		local Fixture = love.physics.newFixture(PhysObj, Shape)
		
		return Shape, Fixture
	end
end

function Entity:CreateRectangleShape(...)
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		local Shape = love.physics.newRectangleShape(...)
		local Fixture = love.physics.newFixture(PhysObj, Shape)
		
		return Shape, Fixture
	end
end

if CLIENT then
	
	function Entity:NewJoint(JointType, SecondEntity, ...)
		if not self:IsValid() or not SecondEntity:IsValid() then
			return nil, "invalid entity"
		end
		
		local PhysObj = self:GetPhysicsObject()
		local PhysObj2 = SecondEntity:GetPhysicsObject()
		if not PhysObj or not PhysObj2 then
			return nil, "invalid physics object"
		end
		
		local Joint
		
		if JointType == "Distance" then
			Joint = love.physics.newDistanceJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Friction" then
			Joint = love.physics.newFrictionJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Gear" then
			Joint = love.physics.newGearJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Prismatic" then
			Joint = love.physics.newPrismaticJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Pulley" then
			Joint = love.physics.newPulleyJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Revolute" then
			Joint = love.physics.newRevoluteJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Rope" then
			Joint = love.physics.newRopeJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Weld" then
			Joint = love.physics.newWeldJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Wheel" then
			Joint = love.physics.newWheelJoint(PhysObj, PhysObj2, ...)
		end
		
		return Joint
	end
	
elseif SERVER then

	function Entity:NewJoint(JointType, SecondEntity, ...)
		if not self:IsValid() or not SecondEntity:IsValid() then
			return nil, "invalid entity"
		end
		
		local PhysObj = self:GetPhysicsObject()
		local PhysObj2 = SecondEntity:GetPhysicsObject()
		if not PhysObj or not PhysObj2 then
			return nil, "invalid physics object"
		end
		
		local Joint
		
		if JointType == "Distance" then
			Joint = love.physics.newDistanceJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Friction" then
			Joint = love.physics.newFrictionJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Gear" then
			Joint = love.physics.newGearJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Prismatic" then
			Joint = love.physics.newPrismaticJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Pulley" then
			Joint = love.physics.newPulleyJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Revolute" then
			Joint = love.physics.newRevoluteJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Rope" then
			Joint = love.physics.newRopeJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Weld" then
			Joint = love.physics.newWeldJoint(PhysObj, PhysObj2, ...)
		elseif JointType == "Wheel" then
			Joint = love.physics.newWheelJoint(PhysObj, PhysObj2, ...)
		end
		
		if Joint then
			local JointDatagram = json.encode {...}
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYJOINT)
				:WriteInt24(self:GetID())
				:WriteInt24(SecondEntity:GetID())
				:WriteLine(JointType)
				:WriteShort(#JointDatagram)
				:WriteString(JointDatagram)
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
		
		return Joint
	end
	
end

function Entity:Initialize(Memory)
end

if SERVER then

	function Entity:Delete()
		local Datagram = ("")
			:WriteShort(CONST.NET.ENTITYDEL)
			:WriteInt24(self:GetID())
		
		Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		self:OnDelete()
	end
	
elseif CLIENT then
	
	function Entity:Delete()
		self:OnDelete()
	end
	
end

function Entity:GetID()
	return tonumber(self.ID)
end

function Entity:GetName()
	return ffi.string(self.Name)
end

function Entity:GetClass()
	return ffi.string(self.Class)
end

function Entity:GetBaseClass()
	return ffi.string(self.BaseClass) or ""
end

function Entity:GetAddress()
	return ffi.string(self.Address)
end

if CLIENT then
	
	function Entity:Move(x, y)
		if type(x) == "number" and type(y) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setPosition(x, y)
			else
				self.x, self.y = x, y
			end
		end
	end

elseif SERVER then

	function Entity:NETMove(x, y)
		if type(x) == "number" and type(y) == "number" then
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYMOVE)
				:WriteInt24(self:GetID())
				:WriteInt(x)
				:WriteInt(y)
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "unsequenced")
		end
	end

	function Entity:Move(x, y)
		if type(x) == "number" and type(y) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setPosition(x, y)
			else
				self.x, self.y = x, y
			end
			self:NETMove(x, y)
		end
	end

end

if CLIENT then

	function Entity:Say(Message)
	end

	function Entity:SayTeam(Message)
	end

elseif SERVER then

	function Entity:Say(Message)
		if type(Message) == "string" then
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYSAY)
				:WriteInt24(self:GetID())
				:WriteLine(Message:gsub("\n", ""))
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end

	function Entity:SayTeam(Message)
		if type(Message) == "string" then
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYSAYTEAM)
				:WriteInt24(self:GetID())
				:WriteLine(Message:gsub("\n", ""))
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

if CLIENT then
	
	function Entity:SetHealth(Health)
		if type(Health) == "number" then
			self.Health = Health
		end
	end
	
elseif SERVER then
	
	function Entity:SetHealth(Health)
		if type(Health) == "number" then
			self.Health = Health
			
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYHEALTH)
				:WriteInt24(self:GetID())
				:WriteInt(Health)
				
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

function Entity:GetHealth()
	return tonumber(self.Health)
end

if CLIENT then
	
	function Entity:SetName(Name)
		if type(Name) == "string" then
			self.Name = Name
		end
	end
	
elseif SERVER then
	
	function Entity:SetName(Name)
		if type(Name) == "string" then
			self.Name = Name
			
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYNAME)
				:WriteInt24(self:GetID())
				:WriteLine(Name)
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

function Entity:GetPosition()
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return PhysObj:getPosition()
	end
	return tonumber(self.x), tonumber(self.y)
end

if CLIENT then
	
	function Entity:SetPosition(x, y)
		if type(x) == "number" and type(y) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setPosition(x, y)
			else
				self.x = x
				self.y = y
			end
		end
	end
	
elseif SERVER then
	
	function Entity:SetPosition(x, y)
		if type(x) == "number" and type(y) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setPosition(x, y)
			else
				self.x = x
				self.y = y
			end
			
			local Message = ("")
				:WriteShort(CONST.NET.ENTITYPOS)
				:WriteInt24(self:GetID())
				:WriteInt(x)
				:WriteInt(y)

			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

function Entity:GetAngle()
	if type(x) == "number" and type(y) == "number" then
		local PhysObj = self:GetPhysicsObject()
		if PhysObj then
			return PhysObj:getAngle()
		end
		return tonumber(self.Angle)
	end
end

if CLIENT then
	
	function Entity:SetAngle(Angle)
		if type(Angle) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setAngle(Angle)
			else
				self.Angle = Angle
			end
		end
	end
	
elseif SERVER then
	
	function Entity:SetAngle(Angle)
		if type(Angle) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setAngle(Angle)
			else
				self.Angle = Angle
			end
			
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYANG)
				:WriteInt24(self:GetID())
				:WriteShort(Angle + 360)

			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

function Entity:Update(dt)
	if self:IsValid() then
		local L = self.LuaStateRef
		
		lua.lua_pushentity(L, self)
		lua.lua_getmetatable(L, -1)
		if lua.lua_istable(L, -1) then
			lua.lua_pop(L, 1)
			lua.lua_getfield(L, -1, "Update")
		
			if lua.lua_isfunction(L, -1) then
				lua.lua_pushentity(L, self)
				if lua.lua_pcall(L, 1, 0, 0) ~= 0 then
					print("Lua Error ["..self:GetClass().."]: "..lua.lua_geterror(L))
				end
			end
		else
			error("UNREGISTERED CLASS "..self:GetClass())
		end
		
	end
end

function Entity:NextUpdate(dt)
	Core.State.EntitiesUQ[love.timer.getTime() + dt] = self
end

function Entity:GetVelocity()
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return PhysObj:getLinearVelocity()
	end
	return 0, 0
end

if CLIENT then
	
	function Entity:SetVelocity(x, y)
		if type(x) == "number" and type(y) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setLinearVelocity(x, y)
			end
		end
	end
	
elseif SERVER then
	
	function Entity:SetVelocity(x, y)
		if type(x) == "number" and type(y) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setLinearVelocity(x, y)
			end
			
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYVEL)
				:WriteInt24(self:GetID())
				:WriteInt(x)
				:WriteInt(y)

			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

function Entity:GetAngularVelocity()
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return PhysObj:getAngularVelocity()
	end
	return 0
end

if CLIENT then

	function Entity:SetAngularVelocity(Velocity)
		if type(Velocity) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setAngularVelocity(Velocity)
			end
		end
	end
	
elseif SERVER then
	
	function Entity:SetAngularVelocity(Velocity)
		if type(Velocity) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setAngularVelocity(Velocity)
			end
			
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYANGVEL)
				:WriteInt24(self:GetID())
				:WriteShort(Velocity + 32767)

			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

function Entity:IsPlayer()
	return false
end

function Entity:IsVehicle()
	return false
end

function Entity:IsUsable()
	return false
end

function Entity:IsWeapon()
	return false
end

function Entity:IsValid()
	if self.ID == ffi.NULL then
		return false
	end
	
	local ValidEntity = Core.State.Entities[self.ID]
	if ValidEntity then
		return ValidEntity.PtrAddress == self.PtrAddress
	end
end

function Entity:IsFrozen()
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return PhysObj:isFrozen()
	end
	return false
end

function Entity:IsSleeping()
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return not PhysObj:isAwake()
	end
	return false
end

function Entity:GetInertia()
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return PhysObj:getInertia()
	end
	return 0
end

if CLIENT then

	function Entity:SetInertia(Inertia)
		if type(Inertia) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setInertia(Inertia)
			end
		end
	end
	
elseif SERVER then
	
	function Entity:SetInertia(Inertia)
		if type(Inertia) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setInertia(Inertia)
			end
			
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYINERTIA)
				:WriteInt24(self:GetID())
				:WriteShort(Inertia + 32767)
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

function Entity:WorldToLocal(x, y)
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return PhysObj:getLocalPoint(x, y)
	end
end

function Entity:LocalToWorld(x, y)
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return PhysObj:getWorldPoint(x, y)
	end
end

function Entity:MassCenter()
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		return PhysObj:getWorldCenter()
	end
	return self.x, self.y
end

if CLIENT then
	
	function Entity:SetMass(Mass)
		if type(Mass) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setMass(Mass)
			end
		end
	end
	
elseif SERVER then
	
	function Entity:SetMass(Mass)
		if type(Mass) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:setMass(Mass)
			end
			
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYMASS)
				:WriteInt24(self:GetID())
				:WriteInt(Mass)
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

function Entity:GetConstraints()
	local Constraints = {}
	local PhysObj = self:GetPhysicsObject()
	if PhysObj then
		local Joints = PhysObj:getJointList()
		for _, Joint in pairs(Joints) do
			local BodyA, BodyB = Joint:getBodies()
			if BodyA == PhysObj then
				table.insert(Constraints, BodyB:getUserData().Entity)
			else
				table.insert(Constraints, BodyA:getUserData().Entity)
			end
		end
	end
	return Constraints
end

if CLIENT then
	
	function Entity:UnConstrain()
		local PhysObj = self:GetPhysicsObject()
		if PhysObj then
			local Joints = PhysObj:getJointList()
			for _, Joint in pairs(Joints) do
				Joint:destroy()
			end
		end
	end
	
elseif SERVER then
	
	function Entity:UnConstrain()
		local PhysObj = self:GetPhysicsObject()
		if PhysObj then
			local Joints = PhysObj:getJointList()
			for _, Joint in pairs(Joints) do
				Joint:destroy()
			end
			
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYUNCONSTRAIN)
				:WriteInt24(self:GetID())
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end
	
end

if CLIENT then
	
	function Entity:ApplyForce(x, y)
		if type(x) == "number" and type(y) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:applyForce(x, y)
			end
		end
	end
	
elseif SERVER then
	
	function Entity:ApplyForce(x, y)
		if type(x) == "number" and type(y) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:applyForce(x, y)
				
				local Datagram = ("")
					:WriteShort(CONST.NET.ENTITYFORCE)
					:WriteInt24(self:GetID())
					:WriteInt(x)
					:WriteInt(y)
				
				Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
			end
		end
	end

end

if CLIENT then
	
	function Entity:ApplyAngForce(Force)
		if type(Force) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:applyAngularImpulse(Force)
			end
		end
	end
	
elseif SERVER then
	
	function Entity:ApplyAngForce(Force)
		if type(Force) == "number" then
			local PhysObj = self:GetPhysicsObject()
			if PhysObj then
				PhysObj:applyAngularImpulse(Force)
				
				local Datagram = ("")
					:WriteShort(CONST.NET.ENTITYANGFORCE)
					:WriteInt24(self:GetID())
					:WriteShort(Force + 32767)
				
				Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
			end
		end
	end
	
end

if CLIENT then
	
	function Entity:Equip(Item)
	end
	
elseif SERVER then
	
	function Entity:Equip(Item)
		local Datagram = ("")
			:WriteShort(CONST.NET.ENTITYEQUIP)
			:WriteInt24(self:GetID())
			:WriteInt24(Item:GetID())
		
		Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
	end
	
end

if CLIENT then
	
	function Entity:GetHoverText()
		return self.Name
	end

	function Entity:GetHoverTextColor()
		return 255, 255, 0
	end

end

if SERVER then
	
	function Entity:Send(Message, Reliable, Sequenced)
		local Datagram = ("")
			:WriteShort(CONST.NET.ENTITYMESSAGE)
			:WriteInt24(self:GetID())
			:WriteString(Message)
			
		local Flag = (Reliable and Sequenced and "reliable") or (Sequenced and "unreliable") or "unsequenced"
		local Address = self.Address
		if type(Address) == "string" then
			local Connection = State.PlayersConnected[self.Address]
			if type(Connection) == "table" then
				if Connection.Peer then
					Connection.Peer:send(Datagram, CONST.NET.CHANNELS.OBJECTS, Flag)
				end
			end
		end
	end

	function Entity:SendBroadcast(Message, Reliable, Sequenced)
		local Datagram = ("")
			:WriteShort(CONST.NET.ENTITYBROADCAST)
			:WriteInt24(self:GetID())
			:WriteString(Message)
		
		local Flag = (Reliable and Sequenced and "reliable") or (Sequenced and "unreliable") or "unsequenced"
		
		Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, Flag)
	end
	
end

if CLIENT then

	function Entity:Receive(Message)
	end

	function Entity:ReceiveBroadcast(Message)
	end

end

function Entity:OnCollide(Source)
	local L = self.LuaStateRef
	
	lua.lua_pushentity(L, self)
	lua.lua_getmetatable(L, -1)
	if lua.lua_istable(L, -1) then
		lua.lua_pop(L, 1)
		lua.lua_getfield(L, -1, "OnCollide")
	
		if lua.lua_isfunction(L, -1) then
			lua.lua_pushentity(L, self)
			if Source then
				lua.lua_pushentity(L, Source)
			else
				lua.lua_pushnil(L)
			end
			if lua.lua_pcall(L, 2, 0, 0) ~= 0 then
				print("Lua Error ["..self:GetClass().."]: "..lua.lua_geterror(L))
			end
		end
	else
		error("UNREGISTERED CLASS "..self:GetClass())
	end
end

function Entity:OnUse(Source)
	local L = self.LuaStateRef
	
	lua.lua_pushentity(L, self)
	lua.lua_getmetatable(L, -1)
	if lua.lua_istable(L, -1) then
		lua.lua_pop(L, 1)
		lua.lua_getfield(L, -1, "OnUse")
	
		if lua.lua_isfunction(L, -1) then
			lua.lua_pushentity(L, self)
			if Source then
				lua.lua_pushentity(L, Source)
			else
				lua.lua_pushnil(L)
			end
			if lua.lua_pcall(L, 2, 0, 0) ~= 0 then
				print("Lua Error ["..self:GetClass().."]: "..lua.lua_geterror(L))
			end
		end
	else
		error("UNREGISTERED CLASS "..self:GetClass())
	end
end

function Entity:OnHit(Source, Damage)
	local L = self.LuaStateRef
	
	lua.lua_pushentity(L, self)
	lua.lua_getmetatable(L, -1)
	if lua.lua_istable(L, -1) then
		lua.lua_pop(L, 1)
		lua.lua_getfield(L, -1, "OnHit")
	
		if lua.lua_isfunction(L, -1) then
			lua.lua_pushentity(L, self)
			if Source then
				lua.lua_pushentity(L, Source)
			else
				lua.lua_pushnil(L)
			end
			lua.lua_pushnumber(L, Damage)
			if lua.lua_pcall(L, 3, 0, 0) ~= 0 then
				print("Lua Error ["..self:GetClass().."]: "..lua.lua_geterror(L))
			end
		end
	else
		error("UNREGISTERED CLASS "..self:GetClass())
	end
end

function Entity:OnDelete()
	local L = self.LuaStateRef
	
	lua.lua_pushentity(L, self)
	lua.lua_getmetatable(L, -1)
	if lua.lua_istable(L, -1) then
		lua.lua_pop(L, 1)
		lua.lua_getfield(L, -1, "OnDelete")
	
		if lua.lua_isfunction(L, -1) then
			lua.lua_pushentity(L, self)
			if lua.lua_pcall(L, 1, 0, 0) ~= 0 then
				print("Lua Error ["..self:GetClass().."]: "..lua.lua_geterror(L))
			end
		end
	else
		error("UNREGISTERED CLASS "..self:GetClass())
	end
end

if CLIENT then
	
	function Entity:OnRender()
		local L = self.LuaStateRef
	
		lua.lua_pushentity(L, self)
		lua.lua_getmetatable(L, -1)
		if lua.lua_istable(L, -1) then
			lua.lua_pop(L, 1)
			lua.lua_getfield(L, -1, "OnRender")
		
			if lua.lua_isfunction(L, -1) then
				lua.lua_pushentity(L, self)
				if lua.lua_pcall(L, 1, 0, 0) ~= 0 then
					print("Lua Error ["..self:GetClass().."]: "..lua.lua_geterror(L))
				end
			end
		else
			error("UNREGISTERED CLASS "..self:GetClass())
		end
	end

	function Entity:SetNETData(Data)
		local L = self.LuaStateRef
	
		lua.lua_pushentity(L, self)
		lua.lua_getmetatable(L, -1)
		if lua.lua_istable(L, -1) then
			lua.lua_pop(L, 1)
			lua.lua_getfield(L, -1, "SetNetData")
		
			if lua.lua_isfunction(L, -1) then
				lua.lua_pushentity(L, self)
				lua.lua_pushrawtable(L, Data)
				if lua.lua_pcall(L, 2, 0, 0) ~= 0 then
					print("Lua Error ["..self:GetClass().."]: "..lua.lua_geterror(L))
				end
			end
		else
			error("UNREGISTERED CLASS "..self:GetClass())
		end
	end
end

function Entity:GetNETData()
	local L = self.LuaStateRef
	
	lua.lua_pushentity(L, self)
	lua.lua_getmetatable(L, -1)
	if lua.lua_istable(L, -1) then
		lua.lua_pop(L, 1)
		lua.lua_getfield(L, -1, "GetNetData")
	
		if lua.lua_isfunction(L, -1) then
			lua.lua_pushentity(L, self)
			if lua.lua_pcall(L, 1, 1, 0) == 0 then
				if lua.lua_istable(L, 1) then
					return lua.lua_totable(L, 1) or {}
				end
			else
				print("Lua Error ["..self:GetClass().."]: "..lua.lua_geterror(L))
			end
		end
	else
		error("UNREGISTERED CLASS "..self:GetClass())
	end
	
	return {}
end

if SERVER then
	
	function Entity:IsSuperAdmin()
	end
	
	function Entity:IsAdmin()
	end

	function Entity:IsModerator()
	end
	
end

if SERVER then
	
	function Entity:SetPlayer(Address)
		if type(Address) == "string" then
			local Datagram = ("")
				:WriteShort(CONST.NET.ENTITYADDRESS)
				:WriteInt24(self:GetID())
				:WriteLine(Address)
			
			Core.Network.SendPlayers(Datagram, CONST.NET.CHANNELS.OBJECTS, "reliable")
		end
	end

end