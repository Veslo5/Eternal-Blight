local consola = {}

function consola:new(name, x, y, width, height)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.name = name
	newInstance.screenX = x
	newInstance.screenY = y
	newInstance.width = width
	newInstance.height = height

	newInstance.textSpacing = 15

	newInstance.texts = {}

	newInstance.nodeDrawID = Observer:observe(CONST_OBSERVE_UI_DRAW, newInstance.name, function() newInstance:draw() end)
	newInstance.nodeAddConsoleTextID = Observer:observe(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, newInstance.name, function(text) newInstance:addText(text) end)

	return newInstance
end

function consola:addText(text)
	table.insert(self.texts, 1, text)
end

function consola:draw()
	-- scissor reacting only in screen are and are not affected by camera!
	local x,y = UICamera:worldToScreen(self.screenX, self.screenY)
	local w,h = UICamera:worldToScreen(self.width, self.height)
	
	love.graphics.setScissor(x,y,w,h)
	--love.graphics.setScissor(self.ScreenX, self.ScreenY, self.Width, self.Height)
	
	--Black rectangle
	love.graphics.setColor(0.1, 0.1, 0.1, 0.5)
	love.graphics.rectangle("fill", self.screenX, self.screenY, self.width, self.height)
	love.graphics.setColor(1, 1, 1)

	for index, text in ipairs(self.texts) do
		local textY = self.screenY + self.height - (self.textSpacing * index)
		love.graphics.print(text, self.screenX, textY)
	end

	love.graphics.setScissor()
end

function consola:unload()
	Observer:stopObserving(CONST_OBSERVE_UI_DRAW, self.nodeDrawID)
	Observer:stopObserving(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, self.nodeAddConsoleTextID)
	Debug:log("[UI] Unloaded UI Consola " .. self.name)

end

return consola
