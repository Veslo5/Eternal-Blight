local debugMenu = {}

function debugMenu.load()
sliceTest = love.graphics.newImage("ext/resources/Slice9.png")
sliceTest:setFilter("nearest", "nearest")
sliceSprite = require("splash.sprites.slice9"):New(sliceTest, 5,5,5,5)
x = 1
y = 1
end

function debugMenu.update(dt) 
	if Input:isActionPressed(CONST_INPUT_EXIT) then
		love.event.quit()
	end

	if love.keyboard.isDown("d") then
		x = x + dt		
	end

	if love.keyboard.isDown("a") then
		x = x - dt		
	end

	if love.keyboard.isDown("s") then
		y = y + dt		
	end
end

function debugMenu.draw()
	love.graphics.setBackgroundColor(1,1,1,1)
--love.graphics.print("DebugMenu", 0,0)
sliceSprite:draw()
end

function debugMenu.keypressed(key, scancode, isrepeat)

end

function debugMenu.keyreleased(key, scancode)

end

function debugMenu.mousepressed(x, y, button, istouch, presses)

end

function debugMenu.mousereleased(x, y, button, istouch, presses)

end

function debugMenu.resize(width, height)

end


function debugMenu.unload()

end

return debugMenu