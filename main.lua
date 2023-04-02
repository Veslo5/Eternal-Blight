---@diagnostic disable: redundant-parameter, undefined-field
require("splash.core.scene")

function love.load()
	--Loading global modules	
	require("splash.core.globals")	

	local limits = love.graphics.getSystemLimits()
	local name, version, vendor, device = love.graphics.getRendererInfo()	
	Debug:log("[CORE] HW Render backend: " .. name .. " " .. version)
	Debug:log("[CORE] HW GPU and GPU vendor: " .. vendor .. " " .. device)
	Debug:log("[CORE] HW Limit max texture size(px): " .. limits.texturesize)	
	

	Scene.Load("bootScene")
end

local debugElapsed = 0

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
				
				if name == "mousereleased" then
					Input:mouseReleased(a,b,c,d,e)
				elseif name == "mousepressed" then
					Input:mousePressed(a,b,c,d,e)
				elseif name == "keyreleased" then
					Input:keyRelease(a,b)
				elseif name == "keypressed" then
					Input:keyPressed(a,b,c)
				end
				
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

		--!DEBUG pulling to catch new breakpoints
		if Debug.isOn then
			--optimization with 1FPS pulling
			--This should not be "that" slow ;)
			debugElapsed =  debugElapsed + dt
			if debugElapsed > 1 / 1 then
				debugElapsed = 0
				Debug.lldebugger.pullBreakpoints()
			end
		end
		--!DEBUG

		Tween.update(dt)
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

--!DEBUG
local love_errorhandler = love.errhand
function love.errorhandler(msg)
    if Debug.running == true then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
--!DEBUG