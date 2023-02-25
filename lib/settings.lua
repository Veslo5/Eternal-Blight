local Settings = {}

function Settings.Load()
	local keybinding = {
		{ActionName = "LEFT", Keys = {"a"," left"}, Pausable = true},
		{ActionName = "RIGHT", Keys = {"d","right"}, Pausable = true},
		{ActionName = "UP", Keys = {"w", "up"}, Pausable = true},
		{ActionName = "DOWN", Keys = {"s","down"}, Pausable = true},
		{ActionName = "EXIT", Keys = {"escape"}, Pausable = false},
		{ActionName = "CONSOLE", Keys = {";"}, Pausable = false}
	}

	for index, value in ipairs(keybinding) do
		local x = value 
	end

end

return Settings