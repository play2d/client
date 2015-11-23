Cache = {
	List = {},
	Request = {},
}

function Cache.Load()
	local File = io.open("sys/core/cache.lst", "rb")
	if File then
		local Content = File:read("*a")
		if #Content > 0 then
			local List = json.decode(Content)
			if type(List) == "table" then
				Cache.List = List
			end
		end
		File:close()
		
		for _, Address in pairs(Cache.List) do
			Peer = Core.Network.Host:connect(Address, CONST.NET.CHANNELS.MAX)
			Cache.Request[Peer] = true
		end
	end
end

function Cache.Save()
	local File = io.open("sys/core/cache.lst", "wb")
	if File then
		local Content = json.encode(Cache.List)
		File:write(Content)
		File:close()
	end
end

function Cache.Connect(Peer)
	Cache.Request[Peer] = nil
	
	local Request = ("")
		:WriteShort(CONST.NET.SERVERINFO)
	
	Peer:send(Request, CONST.NET.CHANNELS.UNCONNECTED, "reliable")
end

function Cache.Disconnect(Peer)
	Cache.Request[Peer] = nil
end

Hook.Add("ENetConnect", Cache.Connect)
Hook.Add("ENetDisconnect", Cache.Disconnect)