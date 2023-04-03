local mapScene = {}

mapScene.UI = require("ext.lib.ui.uiManager")
mapScene.worldManager = require("ext.lib.world.worldManager")
mapScene.drawPipeline = require("ext.lib.graphics.drawPipeline")
mapScene.loader = ResourceLoader:new()

mapScene.loading = false

function mapScene:_loadUI()
	self.UI:load(UICamera.virtualResX, UICamera.virtualResY)
	self.UI:addConsola(CONST_WIDGET_UI_CONSOLA, 0, 0, 500, 250, "left", "bottom")
	self.UI:addTextBox(CONST_WIDGET_UI_TEXTBOX, 0, 0, 500, 30, "left", "bottom")
	self.UI:addToolTip(CONST_WIDGET_UI_TOOLTIP, 0, 0, "right", "bottom")
end

function mapScene.load()
	Input:bind("DEBUG_WALLS", { "p" })

	mapScene:_loadUI()
	mapScene.worldManager:changeMap()
end

function mapScene.update(dt)
	if (Input:isActionPressed("EXIT")) then
		love.event.quit()
	end

	if mapScene.loading == true then
		mapScene.loader:update()
		return
	end
	
	mapScene.UI:update(dt)
	mapScene.worldManager:update(dt)

	if (Input:isActionPressed("CONSOLE")) then
		local textbox = mapScene.UI:getWidget(CONST_WIDGET_UI_TEXTBOX)
		local currentFocus = textbox:getFocus()
		textbox:setFocus(IIF(currentFocus == true, false, true))
	end
end

function mapScene.draw()
	mapScene.drawPipeline:draw(mapScene.worldManager, mapScene.UI, mapScene.loading)
end

--#####CALLBACKS######
function mapScene.keypressed(key, scancode, isrepeat)
	--Input:keypressed(key, scancode, isrepeat)
	mapScene.UI:keyPressed(key)
end

function mapScene.resize(width, height)
	MainCamera:resize(width, height)
	UICamera:resize(width, height)
	mapScene.UI:resize(width, height)
end

function mapScene.textinput(text)
	mapScene.UI:textInput(text)
end

function mapScene.unload()	
	mapScene.drawPipeline:unload()
end

return mapScene
