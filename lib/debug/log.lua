Debug = {}

Debug.IsOn = true

function Debug:Log(messages, ...)
	if self.IsOn then
		print(messages, ...)
	end
end

function Debug:DrawStats()
	if self.IsOn then		
		local stats = love.graphics.getStats()
		love.graphics.print(tostring(love.timer.getFPS()), 0, 0)
		love.graphics.print(tostring(stats.drawcalls), 0, 10)
	end
end