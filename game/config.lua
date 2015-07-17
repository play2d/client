config = {}

function config.load()
	local File = io.open("sys/client.cfg", "r")
	if File then
		for Command in File:lines() do
			parse(Command)
		end
		File:close()
	end
	config.load = nil
end

Hook.Add("load", config.load)