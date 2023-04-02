local debug = {}

debug.serpent = require("lib.external.serpent")

--!DEBUG:
debug.isOn = arg[2] == "debug"
debug.running = arg[3] ~= nil
if debug.isOn then		
    debug.lldebugger = require("lldebugger")
	if(debug.running) then
		debug.lldebugger.start()
	end
end

function debug.start()
	debug.lldebugger.start()
	debug.running = true
	return "started debug hooks."
end

function debug.stop()
	debug.lldebugger.stop()
	debug.running = false
	return "stopped debug hooks."
end

--!DEBUG

--- Logs message
function debug:log(messages, ...)
	if self.isOn then
		print(messages, ...)
	end
end

--- Draw love2D stats
function debug:drawStats()
	--if self.IsOn then		
		local stats = love.graphics.getStats()
		love.graphics.print(tostring(love.timer.getFPS()), 0, 0)
		love.graphics.print(tostring(stats.drawcalls), 0, 10)
	--end
end

--- Generaters string from table
---@param o any
function debug.dump(o)
	return debug.serpent.block(o, {comment = false})
	-- if type(o) == 'table' then
	-- 	local s = '{ '
	-- 	for k, v in pairs(o) do
	-- 		if type(k) ~= 'number' then k = '"' .. k .. '"' end
	-- 		s = s .. '[' .. k .. '] = ' .. Debug.Dump(v) .. ','
	-- 	end
	-- 	return s .. '} '
	-- else
	-- 	return tostring(o)
	-- end
end

return debug