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
	for _, File in pairs(love.filesystem.getDirectoryItems("sys/language")) do
		if love.filesystem.isFile("sys/language/"..File) then
			local Lang = string.match(File, "(.+)%p[%a+]")
			if #Lang > 0 then
				table.insert(List, Lang)
			end
		end
	end
	return List
end

function language.load()
	local Lang = config["cl_lang"]
	if Lang and #Lang > 0 then
		local File = love.filesystem.newFile("sys/language/"..Lang..".txt", "r")
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
	
	for _, Command in pairs(Commands.List) do
		if Command.LoadLanguage then
			local Success, Error = pcall(Command.LoadLanguage)
			if not Success then
				print("Lua Error [Command: "..Command.."]: "..Error)
			end
		end
	end
	language.load = nil
end

Hook.Add("load", language.load)
