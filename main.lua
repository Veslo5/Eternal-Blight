if arg[2] == "debug" then
    require("lldebugger").start()
end

---@diagnostic disable: redundant-parameter, undefined-field
require "scene"

local FIRST_SCENE = "mainRoom"

function love.load()
	require("lib.globals")

	local limits = love.graphics.getSystemLimits()
	local name, version, vendor, device = love.graphics.getRendererInfo()
	Debug:Log("")
	Debug:Log("HW Render backend: " .. name .. " " .. version)
	Debug:Log("HW GPU and GPU vendor: " .. vendor .. " " .. device)
	Debug:Log("HW Limit max texture size(px): " .. limits.texturesize)
	Debug:Log("")
	

	Scene.Load(FIRST_SCENE)
end

-- ref https://love2d.org/wiki/love.run
-- rewrote run function to handle love and scene functions in a "clean" way
function love.run()
	if love.load then
		love.load(love.arg.parseGameArguments(arg), arg)
	end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then
		love.timer.step()
	end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() or not Scene.quit() then
						return a or 0
					end
				end
				love.handlers[name](a, b, c, d, e, f)
				Scene[name](a, b, c, d, e, f) -- handle scene event, if any
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			dt = love.timer.step()
		end
		-- Call update and draw
		if love.update then
			love.update(dt)
		end -- will pass 0 if love.timer is disabled
		Scene.update(dt)

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then
				love.draw()
			end
			Scene.draw()
			love.graphics.present()
		end

		if love.timer then
			love.timer.sleep(0.001)
		end
	end
end
