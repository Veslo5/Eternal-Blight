local loadingScreen = {}

loadingScreen.currentAlpha = 1

loadingScreen.timerHandle = nil

loadingScreen.Loader = ResourceLoader:New()
loadingScreen.LoadedResources = nil
loadingScreen.Loaded = false

function loadingScreen.load()
	loadingScreen.Loader:NewImage("VES", "resources/logo/ves.png")
	loadingScreen.Loader:NewImage("LOVE", "resources/logo/love.png")
	
	loadingScreen.timerHandle =  Timer.after(1, function()
		Tween.to(loadingScreen, 0.5, { currentAlpha = 0 }):oncomplete(function()
			Scene.Load(CONST_SECOND_SCENE)
			end)
		end)

	loadingScreen.LoadedResources = loadingScreen.Loader:LoadAsync(function (data) 
		loadingScreen.LoadedResources = data
		loadingScreen.Loaded = true 
	end)	
end

function loadingScreen.update(dt)

	loadingScreen.Loader:Update(dt)
	if (not loadingScreen.Loaded) then
		return
	end

	Timer.update(dt)

end

function loadingScreen.draw()
	if (not loadingScreen.Loaded) then
		return
	end

	love.graphics.setColor(1, 1, 1, loadingScreen.currentAlpha)
	love.graphics.draw(loadingScreen.LoadedResources[1].Value, 0, 0)
end

function loadingScreen.resize(width, height)
end

function loadingScreen.unload()	
	Timer.clear()
	loadingScreen.LoadedResources = nil
	love.graphics.setColor(1,1,1,1)
end

return loadingScreen
