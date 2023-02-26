local splashScreen = {}

splashScreen.currentAlpha = 1

splashScreen.timerHandle = nil

splashScreen.Loader = ResourceLoader:New()
splashScreen.LoadedResources = nil
splashScreen.Loaded = false

function splashScreen.load()
	Settings.LoadSettings()
	Settings.LoadBindings()
	splashScreen.Loader:NewImage("VES", "resources/logo/ves.png")
	splashScreen.Loader:NewImage("LOVE", "resources/logo/love.png")
	
	splashScreen.timerHandle =  Timer.after(1, function()
		Tween.to(splashScreen, 0.5, { currentAlpha = 0 }):oncomplete(function()
			Scene.Load(CONST_SECOND_SCENE)
			end)
		end)

	splashScreen.LoadedResources = splashScreen.Loader:LoadAsync(function (data) 
		splashScreen.LoadedResources = data
		splashScreen.Loaded = true 
	end)	
end

function splashScreen.update(dt)	
	splashScreen.Loader:Update(dt)
	if (not splashScreen.Loaded) then
		return
	end

	if Input:IsActionPressed(CONST_INPUT_EXIT) then
		love.event.quit()
	end

	Timer.update(dt)

end

function splashScreen.draw()
	if (not splashScreen.Loaded) then
		return
	end

	love.graphics.setColor(1, 1, 1, splashScreen.currentAlpha)
	love.graphics.draw(splashScreen.LoadedResources[1].Value, 0, 0)
end

function splashScreen.resize(width, height)
end

function splashScreen.unload()	
	Timer.clear()
	splashScreen.LoadedResources = nil
	love.graphics.setColor(1,1,1,1)
end

return splashScreen
