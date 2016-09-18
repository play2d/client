local Path, PLAY2D = ...

local Easing = { List = {} }
local EasingMT = {__index = Easing}

-- Class functions
function Easing.new(Type, Duration, Options, UpdateFunction, DoneFunction)
	
	local self = {}
	
	if Type == "linear" then
		
		self.Type = "linear"
		self.State = 1
		self.Clock = 0
		self.Duration = Duration
		
		self.Options = {
				Ping = Options.Ping or false
		}
		
		self.Functions = {
			update = UpdateFunction or false,
			done = DoneFunction or false,
		}
		
		return setmetatable(self, EasingMT)
		
	end
	
end

function Easing:Update(Delta)
	
	if self.Type == "linear" then
		
		self.Clock = self.Clock + (Delta * self.State)

		local updateFunction = self.Functions.update
		if updateFunction then updateFunction() end 

		if self.Clock >= self.Duration then
		
			self.Clock = self.Duration
			
			if self.Options.Ping then
				
				self.State = self.State * -1
			
			else
				
				local doneFunction = self.Functions.done
				if doneFunction then doneFunction() end 
				
				self.State = 0
			
			end
			
		end
		
	end
	
end

function Easing:IsDone()

	return self.State == 0

end

function Easing:getState()

	return self.State

end

function Easing:getProgress()

	return math.floor((self.Clock / self.Duration) * 100)

end

function Easing:getClock()

	return self.Clock

end

return Easing
