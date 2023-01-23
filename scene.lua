local scenesFolder = "levels"

-- Scene is Global object
Scene = {}
local mt =

setmetatable(Scene, { __index = function(t, k)
	if CurrentScene and type(CurrentScene[k]) == "function" then
		return CurrentScene[k]
	end
	return function() end
end })

function Scene.Load(name)

	Debug:Log("Loading scene")
	if CurrentScene then

		local stats = love.graphics.getStats()
		Debug:Log("before drawcalls: " .. stats.drawcalls)
		Debug:Log("before canvasswitches: " .. stats.canvasswitches)
		Debug:Log("before texturememory: " .. stats.texturememory)
		Debug:Log("before images: " .. stats.images)
		Debug:Log("before canvases: " .. stats.canvases)
		Debug:Log("before fonts: " .. stats.fonts)

		Scene.unload()
	end
	local chunk = love.filesystem.load(scenesFolder .. "/" .. name .. ".lua")
	if not chunk then error("Attempt to load scene \"" .. name .. "\", but it was not found in \"" .. scenesFolder .. "\" folder.", 2) end
	CurrentScene = chunk()

	Debug:Log("collected memory before gc:" .. collectgarbage("count"))
	collectgarbage("collect") -- collect all the garbage from unload
	Debug:Log("collected memory after gc:" .. collectgarbage("count"))

	local stats = love.graphics.getStats()
	Debug:Log("after drawcalls: " .. stats.drawcalls)
	Debug:Log("after canvasswitches: " .. stats.canvasswitches)
	Debug:Log("after texturememory: " .. stats.texturememory)
	Debug:Log("after images: " .. stats.images)
	Debug:Log("after canvases: " .. stats.canvases)
	Debug:Log("after fonts: " .. stats.fonts)

	Scene.load()
end