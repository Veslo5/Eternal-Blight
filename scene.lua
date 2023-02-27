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

	table.insert(stringBuilder, "\n[CORE] Loading " .. Scene.LastSceneName)
	
	if CurrentScene then

		local stats = love.graphics.getStats()				
		table.insert(stringBuilder, "[CORE] unloading scene drawcalls: " .. stats.drawcalls)
		table.insert(stringBuilder, "[CORE] unloading scene canvasswitches: " .. stats.canvasswitches)
		table.insert(stringBuilder, "[CORE] unloading scene texturememory: " .. stats.texturememory / 1000000 .. " MB")
		table.insert(stringBuilder, "[CORE] unloading scene images: " .. stats.images)
		table.insert(stringBuilder, "[CORE] unloading scene canvases: " .. stats.canvases)
		table.insert(stringBuilder, "[CORE] unloading scene fonts: " .. stats.fonts)

		
		local memorybeforeGC = collectgarbage("count")	
		table.insert(stringBuilder, "[CORE] before collection lua memory: " .. memorybeforeGC / 1000 .. " MB")

		Scene:unload()		

		collectgarbage("collect") -- collect all the garbage from unload
		local memoryAfterGC = collectgarbage("count")
		table.insert(stringBuilder, "[CORE] collected lua memory: " .. (memorybeforeGC - memoryAfterGC) / 1000 .. " MB")
		table.insert(stringBuilder, "[CORE] current lua memory: " .. memoryAfterGC / 1000 .. " MB" )

	end

	local chunk = love.filesystem.load(scenesFolder .. "/" .. name .. ".lua")
	if not chunk then error("Attempt to load scene \"" .. name .. "\", but it was not found in \"" .. scenesFolder .. "\" folder.", 2) end
	CurrentScene = chunk()

	local stats = love.graphics.getStats()
	table.insert(stringBuilder, "[CORE] new fresh scene: " ..  name)
	table.insert(stringBuilder, "[CORE] fresh scene drawcalls: " .. stats.drawcalls)
	table.insert(stringBuilder, "[CORE] fresh scene canvasswitches: " .. stats.canvasswitches)
	table.insert(stringBuilder, "[CORE] fresh scene texturememory: " .. stats.texturememory / 1000000 .. " MB")
	table.insert(stringBuilder, "[CORE] fresh scene images: " .. stats.images)
	table.insert(stringBuilder, "[CORE] fresh scene canvases: " .. stats.canvases)
	table.insert(stringBuilder, "[CORE] fresh scene fonts: " .. stats.fonts)

	Debug:Log(table.concat(stringBuilder, "\n"))

	Scene:load()
end