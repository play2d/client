Lang = {}
Lang.Translation = {}

function Lang.Get(Code)
	return Lang.Translation[Code] or Code
end

function Lang.Get2(Code, Args)	--> rename to .fget? like in C printf()
	local String = Lang.Translation[Code]
	if String then
		return string.gsub(String, "%$(%u+)", Args or {})
	end
	return Code
end

function Lang.List()
	local List = {}
	for File in lfs.dir("sys/language") do
		if lfs.attributes("sys/language/"..File, "mode") == "file" then
			local Language = string.match(File, "(.+)%p[%a+]")
			if #Language > 0 then
				table.insert(List, Language)
			end
		end
	end
	return List
end

function Lang.Load()
	local Language = Config.CFG["cl_lang"] or ""
	if #Language > 0 then
		local File = io.open("sys/language/"..Language..".txt", "r")
		if File then
			for Line in File:lines() do
				local Key, Value = Line:match("^%s*(.-)%s*=%s*(.-)%s*$")
				if Key and Value then
					Lang.Translation[Key] = Value
				end
			end
			File:close()
		else
			print("Failed to open language file")
		end
	else
		print("Language not found")
	end
	
	for Name, Command in pairs(Commands.List) do
		if Command.LoadLanguage then
			local Success, Error = pcall(Command.LoadLanguage)
			if not Success then
				print("Lua Error [Command: "..Name.."]: "..Error)
			end
		end
	end
	Lang.Load = nil
end
