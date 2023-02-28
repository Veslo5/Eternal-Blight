local splashScreen = {}

function splashScreen.load()
	Settings.LoadSettings()
	Settings.LoadBindings()
	
	splashScreen.UI = require("lib.ui.uiManager")

	splashScreen.currentAlpha = 1

	splashScreen.Loader = nil
	splashScreen.Loaded = false


	splashScreen.Loader =  ResourceLoader:New()	
	splashScreen.UI:Load(UICamera.VirtualResX, UICamera.VirtualResY)

	splashScreen.Loader:NewImage("VES", "resources/logo/ves.png")
	--splashScreen.Loader:NewImage("LOVE", "resources/logo/love.png")

	Timer.after(1, function()
		Tween.to(splashScreen, 0.5, { currentAlpha = 0 }):oncomplete(function()
			Scene.Load(CONST_SECOND_SCENE)
		end)
	end)

	splashScreen.Loader:LoadAsync(function(data)
		local image = splashScreen.UI:AddImage("VES", data[1].Value, 0, 0, "center", "center")				
		--splashScreen.UI:AddImage("LOVE", data[2].Value, 0,0, "center", "center")
		splashScreen.Loaded = true		
	end)

end

function splashScreen.update(dt)	
	splashScreen.Loader:Update(dt)
	if (not splashScreen.Loaded) then
		return
	end


	-- if Input:IsActionDown(CONST_INPUT_UP) then
	-- 	UICamera:SetZoom(dt)				
	-- end

	-- if Input:IsActionDown(CONST_INPUT_DOWN) then
	-- 	UICamera:SetZoom(-dt)	
	-- end

	if Input:IsActionPressed(CONST_INPUT_EXIT) then
		love.event.quit()
	end

	if Input:IsActionPressed(CONST_INPUT_CONSOLE) then
		Scene.Load("splashScreen")
	end

	Timer.update(dt)
end

function splashScreen.draw()
	if (not splashScreen.Loaded) then
		return
	end

	love.graphics.setColor(1, 1, 1, splashScreen.currentAlpha)
	
	
	UICamera:BeginDraw()
	splashScreen.UI:Draw()
	love.graphics.rectangle("line", 0,0, 1366, 768)
	love.graphics.rectangle("line", 0,0, 1920, 1080)

	love.graphics.setColor(1,1,1,1)	
	UICamera:EndDraw()
end

function splashScreen.resize(width, height)

end

function splashScreen.unload()
	Timer.clear()
	splashScreen.UI:Unload()
	love.graphics.setColor(1, 1, 1, 1)
end

return splashScreen
