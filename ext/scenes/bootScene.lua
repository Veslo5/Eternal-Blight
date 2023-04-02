local splashScreen = {}

function splashScreen.load()
	Settings.loadSettings()
	Settings.loadBindings()
	
	splashScreen.UI = require("lib.ui.uiManager")

	splashScreen.currentAlpha = 1

	splashScreen.loader = nil
	splashScreen.loaded = false


	splashScreen.loader =  ResourceLoader:new()	
	splashScreen.UI:load(UICamera.virtualResX, UICamera.virtualResY)

	splashScreen.loader:newImage("VES", "ext/resources/logo/ves.png")
	--splashScreen.Loader:NewImage("LOVE", "ext/resources/logo/love.png")

	Timer.after(1, function()
		Tween.to(splashScreen, 0.5, { currentAlpha = 0 }):oncomplete(function()
			Scene.Load(CONST_SECOND_SCENE)
		end)
	end)

	splashScreen.loader:loadAsync(function(data)
		local image = splashScreen.UI:addImage("VES", data[1].value, 0, 0, "center", "center")				
		--splashScreen.UI:AddImage("LOVE", data[2].Value, 0,0, "center", "center")
		splashScreen.loaded = true		
	end)

end

function splashScreen.update(dt)	
	splashScreen.loader:update(dt)
	if (not splashScreen.loaded) then
		return
	end


	-- if Input:IsActionDown(CONST_INPUT_UP) then
	-- 	UICamera:SetZoom(dt)				
	-- end

	-- if Input:IsActionDown(CONST_INPUT_DOWN) then
	-- 	UICamera:SetZoom(-dt)	
	-- end

	if Input:isActionPressed(CONST_INPUT_EXIT) then
		love.event.quit()
	end

	if Input:isActionPressed(CONST_INPUT_CONSOLE) then
		Scene.Load("splashScreen")
	end

	Timer.update(dt)
end

function splashScreen.draw()
	if (not splashScreen.loaded) then
		return
	end

	love.graphics.setColor(1, 1, 1, splashScreen.currentAlpha)
		
	UICamera:beginDraw()
	splashScreen.UI:draw()

	love.graphics.setColor(1,1,1,1)	
	UICamera:endDraw()
end

function splashScreen.resize(width, height)
	UICamera:resize(width, height)
end

function splashScreen.unload()
	Timer.clear()
	splashScreen.UI:unload()
	love.graphics.setColor(1, 1, 1, 1)
end

return splashScreen
