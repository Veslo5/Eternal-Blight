local mapScene = {}

mapScene.UI = require("lib.ui.uiManager")
mapScene.tiled = require("lib.tilemap.tiled"):new()
mapScene.worldManager = require("lib.world.worldManager")
mapScene.loading = true
mapScene.currentMap = nil


function mapScene:_loadingScreen()
	love.graphics.print("Loading...",50,50)
end

function mapScene:_loadWorldManager(tiled)
	
	mapScene.worldManager:setupMapData(
		tiled.tilemapLoader.tileMapMetadata.width,
		tiled.tilemapLoader.tileMapMetadata.height,
		tiled.tilemapLoader.tileMapMetadata.tilewidth,
		tiled.tilemapLoader.tileMapMetadata.tileheight)

	local dataTileGroup = tiled.tilemapLoader:getGroupLayer("Data")

	if(dataTileGroup ~= nil) then
		mapScene.worldManager:setupWalls(dataTileGroup)    
	end

	-- Sandbox -------------------------------------------------- TESTING
	local entityBuilder = require("lib.world.entityBuilder")
	local playerEntity = entityBuilder:new("Player")
	playerEntity:makeGridMovable(1,1)
	playerEntity:makeControllable(true, true)
	playerEntity:makeDrawable()

	MainCamera:follow(playerEntity.IDrawable, "worldX", "worldY")

	mapScene.worldManager:addEntity(playerEntity)

	local systemBuilder = require("lib.world.systemBuilder")

	mapScene.worldManager:addSystem(systemBuilder.getMoveSystem())
	mapScene.worldManager:addSystem(systemBuilder.getDrawSystem())
	mapScene.worldManager:addSystem(systemBuilder.getRoundSystem())
	mapScene.worldManager:ecsInit()

	local mob = Filesystem:loadMob("snake")

end

function mapScene:_loadUI()
	self.UI:load(UICamera.virtualResX, UICamera.virtualResY)
	self.UI:addConsola(CONST_WIDGET_UI_CONSOLA, 0,0,500,250, "left", "bottom")
	self.UI:addTextBox(CONST_WIDGET_UI_TEXTBOX, 0,0,500,30, "left", "bottom")
end

--TODO refactoring needed here!
function mapScene:_changeMap(mapName)
	self.loading = true

	
	if self.currentMap ==  nil then
		self.tiled:load(CONST_INIT_MAP, self.loader)	
		mapName = CONST_INIT_MAP
	else
		Debug:log("[CORE] Changing map to " .. mapName)

		self.worldManager:unload()
		self.tiled:unload()

		self.tiled:load(mapName, self.loader)	
	end

	collectgarbage("collect")
	
	self:_loadWorldManager(self.tiled)	
	self.currentMap = mapName
	self.loading = false

	print("[CORE] Map changed: current mapScene textures " .. love.graphics.getStats().images)


end

function mapScene.load()
	Input:bind("DEBUG_WALLS", {"p"})
	
	mapScene.loader =  ResourceLoader:new()
	mapScene:_loadUI()
	mapScene:_changeMap()
end

function mapScene.update(dt)
	if (Input:isActionPressed("EXIT")) then
		love.event.quit()
	end

	if mapScene.loading then
		mapScene:_loadingScreen()
		return
	end	

	mapScene.tiled:update(dt)
	mapScene.UI:update(dt)
	mapScene.worldManager:update(dt)
	
	if (Input:isActionPressed("CONSOLE")) then
		if mapScene.currentMap == "data/test_map002.lua" then
			mapScene:_changeMap(CONST_INIT_MAP)
		else
			mapScene:_changeMap("data/test_map002.lua")
		end
		-- local textbox = mapScene.UI:getWidget(CONST_WIDGET_UI_TEXTBOX)
		-- local currentFocus = textbox:getFocus()
		-- textbox:setFocus(IIF(currentFocus == true, false, true))
	end 

	
end

function mapScene.draw()
	love.graphics.setBackgroundColor(0,0,0,1)

	if mapScene.loading then
		mapScene:_loadingScreen()
		return
	end


	-- Gameplay rendering
	MainCamera:beginDraw()
	do
		mapScene.tiled:draw()
		mapScene.worldManager:draw()
	end
	MainCamera:endDraw()
	
	-- UI rendering    
	UICamera:beginDraw()
	do
		Debug:drawStats()
		mapScene.UI:draw()
	end
	UICamera:endDraw()
end

--#####CALLBACKS######
function mapScene.keypressed(key, scancode, isrepeat)
	--Input:keypressed(key, scancode, isrepeat)
	mapScene.UI:keyPressed(key)
end

function mapScene.resize(width, height)
	MainCamera:resize(width,height)
	UICamera:resize(width,height)
	mapScene.UI:resize(width,height)
end

function mapScene.textinput(text)
	mapScene.UI:textInput(text)
end

function mapScene.unload()
	mapScene.tiled:unload()
end

return mapScene