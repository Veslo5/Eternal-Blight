local settings = {}

function settings.loadBindings()
	Debug:log("[SETTINGS] Loading keybindings")

	local keybinding = {
		{ actionName = "LEFT",    keys = { "a", "left" },  pausable = true },
		{ actionName = "RIGHT",   keys = { "d", "right" }, pausable = true },
		{ actionName = "UP",      keys = { "w", "up" },    pausable = true },
		{ actionName = "DOWN",    keys = { "s", "down" },  pausable = true },
		{ actionName = "EXIT",    keys = { "escape" },     pausable = false },
		{ actionName = "CONSOLE", keys = { ";" },          pausable = false }
	}

	local fileExists = love.filesystem.getInfo("bindings.lua", "file")
	if not fileExists then
		local file = love.filesystem.newFile("bindings.lua")
		if file:open("w") then
			file:write("return " .. Debug.dump(keybinding))
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
		Input:bind(value.actionName, value.keys, value.pausable)
	end
end

function settings.loadSettings()
	Debug:log("[SETTINGS] Loading settings")
	local settings = {
		vsync = 0,
		fullScreen = true,
		fullScreenType = "desktop",
		resolutionX = 0,
		resolutionY = 0
	}

	local fileExists = love.filesystem.getInfo("settings.lua", "file")
	if not fileExists then
		local file = love.filesystem.newFile("settings.lua")
		if file:open("w") then
			file:write("return " .. Debug.dump(settings))
		end
		file:close()
	else
		local chunk, err = love.filesystem.load("settings.lua")
		if err then
			error(err)
		end

		settings = chunk()
	end

	love.window.setMode(settings.resolutionX, settings.resolutionY, {
		vsync = settings.vsync,
		fullscreen = settings.fullScreen,
		fullscreentype = settings.fullScreenType		
	})
	settings.resolutionX = love.graphics.getWidth()
	settings.resolutionY = love.graphics.getHeight()

	UICamera:resize(settings.resolutionX, settings.resolutionY)
	MainCamera:resize(settings.resolutionX, settings.resolutionY)
end

return settings
