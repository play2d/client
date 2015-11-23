Cache = {
	List = {},
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
		Interface.Servers.Refresh()
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