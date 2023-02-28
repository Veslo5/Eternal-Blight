local Consola = {}

function Consola:New(name, x, y, width, height)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.Name = name
	newInstance.ScreenX = x
	newInstance.ScreenY = y
	newInstance.Width = width
	newInstance.Height = height

	newInstance.TextSpacing = 15

	newInstance.Texts = {}

	newInstance.NodeDrawID = Observer:Observe(CONST_OBSERVE_UI_DRAW, newInstance.Name, function() newInstance:Draw() end)
	newInstance.NodeAddConsoleTextID = Observer:Observe(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, newInstance.Name, function(text) newInstance:AddText(text) end)

	return newInstance
end

function Consola:AddText(text)
	table.insert(self.Texts, 1, text)
end

function Consola:Draw()
	-- scissor reacting only in screen are and are not affected by camera!
	local x,y = UICamera:WorldToScreen(self.ScreenX, self.ScreenY)
	local w,h = UICamera:WorldToScreen(self.Width, self.Height)
	
	love.graphics.setScissor(x,y,w,h)
	--love.graphics.setScissor(self.ScreenX, self.ScreenY, self.Width, self.Height)
	
	--Black rectangle
	love.graphics.setColor(0.1, 0.1, 0.1, 0.5)
	love.graphics.rectangle("fill", self.ScreenX, self.ScreenY, self.Width, self.Height)
	love.graphics.setColor(1, 1, 1)

	for index, text in ipairs(self.Texts) do
		local textY = self.ScreenY + self.Height - (self.TextSpacing * index)
		love.graphics.print(text, self.ScreenX, textY)
	end

	love.graphics.setScissor()
end

function Consola:Unload()
	Observer:StopObserving(CONST_OBSERVE_UI_DRAW, self.NodeDrawID)
	Observer:StopObserving(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, self.NodeAddConsoleTextID)
	Debug:Log("[UI] Unloaded UI Consola " .. self.Name)

end

return Consola
