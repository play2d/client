local State = Core.State
local LuaState = Core.LuaState

Hook.Create("StartRound")

function State.Renew()
	-- This is pretty much a changemap
	
	if not State.Map then
		error("FAILED TO LOAD MAP")
	end

	LuaState.Renew()
	
	State.Mode = "Play2D"
	State.Start = love.timer.getTime()
	
	State.PlayersConnected = {}
	
	State.ConVars = {}
	State.Entities = {}
	State.EntitiesUQ = {}				-- Update Queue
	
	LuaState.Load()
	State.Map:GenerateWorld()
	
	Hook.Call("StartRound")
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