if not CLIENT then
	return nil
end

return {
	Call = function (Source, File)
		if Source.source == "game" then
			Core.Microphone.Update()
		end
	end
}