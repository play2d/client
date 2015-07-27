config = {}

-- Default configuration
config["name"] = "Player"
config["relativemovement"] = 0

function config.load()
	local File = love.filesystem.newFile("sys/client.cfg", "r")
	if File then
		for Command in File:lines() do
			if Command:sub(1, 2) ~= "//" then
				parse(Command)
			end
		end
		File:close()
	end
	config.load = nil
end

Hook.Add("load", config.load)
