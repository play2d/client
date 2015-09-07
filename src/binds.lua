Binds = {}
Binds.List = {}

function Binds.Create(Text, Command)
	table.insert(Binds.List, {Text, Command})
end

function Binds.Find(Command)
	for Key, BoundCommand in pairs(config["bind"]) do
		if Command == BoundCommand then
			return Key
		end
	end
end

function Binds.Reload()
	Options.Controls.List:ClearItems()
	for _, Pack in pairs(Binds.List) do
		local BindFound
		if config["bind"] then
			for Key, BoundCommand in pairs(config["bind"]) do
				if Pack[2] == BoundCommand then
					Options.Controls.List:AddItem(Pack[1], Key)
					BindFound = true
					break
				end
			end
		end
		if not BindFound then
			Options.Controls.List:AddItem(Keyword, "")
		end
	end
	if Options.Controls.Field then
		Options.Controls.Field:SetText("")
	end
end