game.Binds = {}

-- This is not the official list for the binds, the used configuration is stored at config["bind"] on sys/commands/bind.lua
game.Binds.List = {}

function game.Binds.Find(Command)
	for Key, BoundCommand in pairs(config["bind"]) do
		if Command == BoundCommand then
			return Key
		end
	end
end

function game.Binds.Reload()
	game.ui.Options.ControlsList:ClearItems()
	for _, Pack in pairs(game.Binds.List) do
		local BindFound
		if config["bind"] then
			for Key, BoundCommand in pairs(config["bind"]) do
				if Pack[2] == BoundCommand then
					game.ui.Options.ControlsList:AddItem(Pack[1], Key)
					BindFound = true
					break
				end
			end
		end
		if not BindFound then
			game.ui.Options.ControlsList:AddItem(Keyword, "")
		end
	end
	if game.ui.Options.ControlsField then
		game.ui.Options.ControlsField:SetText("")
	end
end