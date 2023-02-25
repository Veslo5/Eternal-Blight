local loadingScreen = {}


loadingScreen.fade = false
loadingScreen.currentAlpha = 1

loadingScreen.timer = Timer.new()
loadingScreen.vesLogo = nil
loadingScreen.loveLogo = nil


function loadingScreen.load()

loadingScreen.vesLogo = love.graphics.newImage("resources/logo/ves.png")
loadingScreen.loveLogo = love.graphics.newImage("resources/logo/love.png")
loadingScreen.timer:after(1, function () loadingScreen.fade = true  end)


end

function loadingScreen.update(dt) 
loadingScreen.timer:update(dt)

	if loadingScreen.fade == true then
		Tween.to(loadingScreen, 0.5, {currentAlpha = 0}):oncomplete(function () print("ended") end)
	end

end

function loadingScreen.draw()

	love.graphics.setColor(1,1,1, loadingScreen.currentAlpha)
	love.graphics.draw(loadingScreen.vesLogo, 0,0)

end

function loadingScreen.keypressed(key, scancode, isrepeat)

end

function loadingScreen.keyreleased(key, scancode)

end

function loadingScreen.mousepressed(x, y, button, istouch, presses)

end

function loadingScreen.mousereleased(x, y, button, istouch, presses)

end

function loadingScreen.resize(width, height)

end

function loadingScreen.textinput(text)

end

function loadingScreen.unload()

end

return loadingScreen