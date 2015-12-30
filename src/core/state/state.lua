local State = Core.State
local LuaState = Core.LuaState

Hook.Create("StartRound")

function State.Renew()
	-- Changemap
	State.Start = love.timer.getTime()
	State.PlayersConnected = {}
	
	State.ConVars = {}
	State.Entities = {}
	State.EntitiesUQ = {}				-- Update Queue

	State.Map:GenerateWorld()
	
	Hook.Call("StartRound")
end

function State.Destroy()
	State.Map = nil
	State.Mode = nil
	State.Start = nil
	State.PlayersConnected = nil
	State.ConVars = nil
	State.Entities = nil
	State.EntitiesUQ = nil
end

function State.Reset()
	-- This is a map restart, it removes stuff
	
	State.Entities = {}
	State.EntitiesUQ = {}

	if State.Map then
		State.Map:GenerateWorld()
	end
	
	Hook.Call("StartRound")
end

function State.Update(dt)
	if State.Entities then
		local Entities = State.EntitiesUQ
		local CurrentTime = love.timer.getTime()
		
		for Time, Entity in pairs(Entities) do
			if CurrentTime <= Time then
				Entities[Time] = nil
				LuaState.State:pcall(Entity.Update, Entity)
			end
		end
	end
	
	if State.Map then
		State.Map.World:update(dt)
	end
end