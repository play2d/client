language = {}
language.translation = {}

function language.get(code)
	return language.translation[code] or code
end

function language.get2(code, args)	--> rename to .fget? like in C printf()
	local String = language.translation[code]
	if String then
		return string.gsub(String, "%$(%u+)", args or {})
	end
	return code
end

function language.list()
	local List = {}
	for File in lfs.dir("sys/language") do
		if lfs.attributes("sys/language/"..File, "mode") == "file" then
			local Lang = string.match(File, "(.+)%p[%a+]")
			if #Lang > 0 then
				table.insert(List, Lang)
			end
		end
	end
	return List
end

function language.load()
	local Lang = config["lang"]
	if Lang and #Lang > 0 then
		local File = io.open("sys/language/"..Lang..".txt", "r")
		if File then
			for Line in File:lines() do
				local Key, Value = Line:match("^%s*(.-)%s*=%s*(.-)%s*$")
				if Key and Value then
					language.translation[Key] = Value
				end
			end
			File:close()
		else
			print("Failed to open language file")
		end
	else
		print("Language not found")
	end
	language.load = nil
end

Hook.Add("load", language.load)
