local Textbox        = {}

Textbox.ReceiveInput = true
Textbox.Enabled      = false
Textbox.ScreenX      = 0
Textbox.ScreenY      = 0
Textbox.Width        = 0
Textbox.Height       = 0

Textbox.Text         = ""

Textbox.CursorX      = 0

function Textbox:New(x, y, width, height, enabled)
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	newInstance.ScreenX = x
	newInstance.ScreenY = y
	newInstance.Width = width
	newInstance.Height = height
	newInstance.Enabled = enabled ~= false

	Observer:Observe(CONST_OBSERVE_UI_DRAW, function() newInstance:Draw() end)
	Observer:Observe(CONST_OBSERVE_UI_TEXTINPUT, function(text) newInstance:TextInput(text) end)

	return newInstance
end

function Textbox:TextInput(text)
	if self.Enabled then
		Textbox.Text = Textbox.Text .. text
	end
end

function Textbox:Draw()
	love.graphics.setColor(0.1, 0.1, 0.1, 0.5)
	love.graphics.rectangle("fill", self.ScreenX, self.ScreenY, self.Width, self.Height)
	love.graphics.setColor(1, 1, 1)

	love.graphics.rectangle("fill", self.ScreenX, self.ScreenY + self.Height - 5, 5, 2)

	love.graphics.print(self.Text, self.ScreenX, self.ScreenY + 10)
end

return Textbox
