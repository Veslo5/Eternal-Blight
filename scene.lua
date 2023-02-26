local scenesFolder = "scenes"

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

	Scene.LastSceneName = name
	local stringBuilder = {}

	table.insert(stringBuilder, "\nLoading " .. Scene.LastSceneName)
	
	if CurrentScene then

		local stats = love.graphics.getStats()				
		table.insert(stringBuilder, "drawcalls: " .. stats.drawcalls)
		table.insert(stringBuilder, "canvasswitches: " .. stats.canvasswitches)
		table.insert(stringBuilder, "texturememory: " .. stats.texturememory / 1000000 .. " MB")
		table.insert(stringBuilder, "images: " .. stats.images)
		table.insert(stringBuilder, "canvases: " .. stats.canvases)
		table.insert(stringBuilder, "fonts: " .. stats.fonts)

		Scene:unload()

		local memorybeforeGC = collectgarbage("count")	
		table.insert(stringBuilder, "before collection lua memory: " .. memorybeforeGC / 1000 .. " MB")
		collectgarbage("collect") -- collect all the garbage from unload
		local memoryAfterGC = collectgarbage("count")
		table.insert(stringBuilder, "collected lua memory: " .. (memorybeforeGC - memoryAfterGC) / 1000 .. " MB")
		table.insert(stringBuilder, "current lua memory: " .. memoryAfterGC / 1000 .. " MB" )

	end

	local chunk = love.filesystem.load(scenesFolder .. "/" .. name .. ".lua")
	if not chunk then error("Attempt to load scene \"" .. name .. "\", but it was not found in \"" .. scenesFolder .. "\" folder.", 2) end
	CurrentScene = chunk()

	local stats = love.graphics.getStats()
	table.insert(stringBuilder, "new scene: " ..  name)
	table.insert(stringBuilder, "drawcalls: " .. stats.drawcalls)
	table.insert(stringBuilder, "canvasswitches: " .. stats.canvasswitches)
	table.insert(stringBuilder, "texturememory: " .. stats.texturememory / 1000000 .. " MB")
	table.insert(stringBuilder, "images: " .. stats.images)
	table.insert(stringBuilder, "canvases: " .. stats.canvases)
	table.insert(stringBuilder, "fonts: " .. stats.fonts)

	Debug:Log(table.concat(stringBuilder, "\n"))

	Scene:load()
end