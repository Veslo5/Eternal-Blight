local debugMenu = {}

function debugMenu.load()

end

function debugMenu.update(dt) 
	if Input:isActionPressed(CONST_INPUT_EXIT) then
		love.event.quit()
	end
end

function debugMenu.draw()
love.graphics.print("DebugMenu", 0,0)
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