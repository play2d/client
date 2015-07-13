config = {}

function config.load()
	local File = love.filesystem.newFile("sys/client.cfg")
	if File then
		for Command in File:lines() do
			parse(Command)
		end
	end
	config.load = nil
end
