local Settings = {}

function Settings.LoadBindings()
	Debug:Log("[SETTINGS] Loading keybindings")

	local keybinding = {
		{ ActionName = "LEFT",    Keys = { "a", "left" },  Pausable = true },
		{ ActionName = "RIGHT",   Keys = { "d", "right" }, Pausable = true },
		{ ActionName = "UP",      Keys = { "w", "up" },    Pausable = true },
		{ ActionName = "DOWN",    Keys = { "s", "down" },  Pausable = true },
		{ ActionName = "EXIT",    Keys = { "escape" },     Pausable = false },
		{ ActionName = "CONSOLE", Keys = { ";" },          Pausable = false }
	}

	local fileExists = love.filesystem.getInfo("bindings.lua", "file")
	if not fileExists then
		local file = love.filesystem.newFile("bindings.lua")
		if file:open("w") then
			file:write("return " .. Debug.Dump(keybinding))
		end
		file:close()
	else
		local chunk, err = love.filesystem.load("bindings.lua")
		if err then
			error(err)
		end

		keybinding = chunk()
	end

	for index, value in ipairs(keybinding) do
		Input:Bind(value.ActionName, value.Keys, value.Pausable)
	end
end

function Settings.LoadSettings()
	Debug:Log("[SETTINGS] Loading settings")
	local settings = {
		Vsync = 0,
		FullScreen = true,
		FullScreenType = "desktop",
		ResolutionX = 1366,
		ResolutionY = 768
	}

	local fileExists = love.filesystem.getInfo("settings.lua", "file")
	if not fileExists then
		local file = love.filesystem.newFile("settings.lua")
		if file:open("w") then
			file:write("return " .. Debug.Dump(settings))
		end
		file:close()
	else
		local chunk, err = love.filesystem.load("settings.lua")
		if err then
			error(err)
		end

		settings = chunk()
	end

	love.window.setMode(settings.ResolutionX, settings.ResolutionY, {
		vsync = settings.Vsync,
		fullscreen = settings.FullScreen,
		fullscreentype = settings.FullScreenType
	})

	UICamera:Resize(settings.ResolutionX, settings.ResolutionY)
	MainCamera:Resize(settings.ResolutionX, settings.ResolutionY)
end

return Settings
