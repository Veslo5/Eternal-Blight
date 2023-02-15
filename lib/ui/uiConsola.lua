local Consola = {}

Consola.ScreenX = 0
Consola.ScreenY = 0

Consola.Width = 0
Consola.Height = 0

Consola.TextSpacing = 15

Consola.TextboxHeight = 30

Consola.Texts = {}

function Consola:New(x,y,width,height)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.ScreenX = x
	newInstance.ScreenY = y
	newInstance.Width = width
	newInstance.Height = height

	return newInstance
end

function Consola:AddText(text)
	table.insert(self.Texts, 1, text)
end

function Consola:Update()

end

function Consola:Draw()
	--Black rectangle
	love.graphics.setColor(0.1, 0.1, 0.1 , 0.5)
	love.graphics.rectangle("fill", self.ScreenX, self.ScreenY, self.Width, self.Height - self.TextboxHeight - 1)
	love.graphics.rectangle("fill", self.ScreenX, self.ScreenY + self.Height - self.TextboxHeight, self.Width, self.TextboxHeight)
	love.graphics.setColor(1, 1, 1)

	for index, text in ipairs(self.Texts) do
		local textY = self.ScreenY + self.Height - (self.TextSpacing * index)
		love.graphics.print(text,self.ScreenX, textY)
	end
end

return Consola
