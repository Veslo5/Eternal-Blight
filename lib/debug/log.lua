local Debug = {}

--!DEBUG:
Debug.IsOn = arg[2] == "debug"
if Debug.IsOn then
	print("Starting debug session!")
	-- require("lldebugger").start()
    Debug.lldebugger = require("lldebugger")
	Debug.lldebugger.start()
end

--- Logs message
function Debug:Log(messages, ...)
	if self.IsOn then
		print(messages, ...)
	end
end

--- Draw love2D stats
function Debug:DrawStats()
	if self.IsOn then		
		local stats = love.graphics.getStats()
		love.graphics.print(tostring(love.timer.getFPS()), 0, 0)
		love.graphics.print(tostring(stats.drawcalls), 0, 10)
	end
end

--- Generaters string from table
---@param o any
function Debug.Dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. Debug.Dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

return Debug