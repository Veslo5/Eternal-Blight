local Consola = {}

Consola.ReceiveInput = false
Consola.ScreenX = 0
Consola.ScreenY = 0

Consola.Width = 0
Consola.Height = 0

Consola.TextSpacing = 15

Consola.Texts = {}

function Consola:New(x, y, width, height)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.ScreenX = x
	newInstance.ScreenY = y
	newInstance.Width = width
	newInstance.Height = height

	Observer:Observe(CONST_OBSERVE_UI_DRAW, function() newInstance:Draw() end)
	Observer:Observe(CONST_OBSERVE_UI_ADD_CONSOLE_TEXT, function (text) newInstance:AddText(text) end)

	return newInstance
end



function Consola:AddText(text)
	table.insert(self.Texts, 1, text)
end

function Consola:Draw()
	--Black rectangle
	love.graphics.setScissor(self.ScreenX, self.ScreenY, self.Width, self.Height)
	
	love.graphics.setColor(0.1, 0.1, 0.1, 0.5)
	love.graphics.rectangle("fill", self.ScreenX, self.ScreenY, self.Width, self.Height)
	love.graphics.setColor(1, 1, 1)

	for index, text in ipairs(self.Texts) do
		local textY = self.ScreenY + self.Height - (self.TextSpacing * index)
		love.graphics.print(text, self.ScreenX, textY)
	end

	love.graphics.setScissor( )
end

return Consola
