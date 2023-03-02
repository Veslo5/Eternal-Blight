local mapScene = {}

mapScene.UI = require("lib.ui.uiManager")
mapScene.tilemapRenderer = require("lib.tilemap.tilemapRenderer")
mapScene.tilemapLoader = require("lib.tilemap.tilemapLoader"):new()
mapScene.worldManager = require("lib.world.worldManager")

function mapScene.load()
	Input:bind("DEBUG_WALLS", {"p"})
	
	mapScene.loader =  ResourceLoader:new()

	mapScene.UI:load(UICamera.virtualResX, UICamera.virtualResY)
	mapScene.UI:addConsola(CONST_WIDGET_UI_CONSOLA, 0,0,500,250, "left", "bottom")
	mapScene.UI:addTextBox(CONST_WIDGET_UI_TEXTBOX, 0,0,500,30, "left", "bottom")

	local tilemaploader = mapScene.tilemapLoader
	tilemaploader:loadMetadata(CONST_INIT_MAP)

	for _, tilemapImage in ipairs(tilemaploader:getResourcesFromTilesets()) do
		-- adds resources to loading queue
		mapScene.loader:newImage(tilemapImage.name, tilemapImage.image)
	end

	local data = mapScene.loader:loadSync()

	mapScene.tilemapRenderer:createRenderers(tilemaploader.tileMapMetadata, data)	

	local mapSizeX = tilemaploader.tileMapMetadata.width
	local mapSizeY = tilemaploader.tileMapMetadata.height
	local mapTileWidth = tilemaploader.tileMapMetadata.tilewidth
	local mapTileHeight = tilemaploader.tileMapMetadata.tileheight

	local currentAtlas = mapScene.tilemapRenderer.tileSetAtlases

	mapScene.worldManager:setupMapData(mapSizeX, mapSizeY, mapTileWidth, mapTileHeight)

	local dataTileGroup = tilemaploader:getGroupLayer("Data")
	
	if(dataTileGroup ~= nil) then
	mapScene.worldManager:setupWalls(dataTileGroup)    
	end

-- Sandbox --------------------------------------------------
	local entityBuilder = require("lib.world.entityBuilder")
	local playerEntity = entityBuilder:new("Player")
	playerEntity:makeGridMovable(1,1)
	playerEntity:makeControllable(true, true)
	playerEntity:makeDrawable()

	
	mapScene.worldManager:addEntity(playerEntity)

	local systemBuilder = require("lib.world.systemBuilder")

	mapScene.worldManager:addSystem(systemBuilder.getMoveSystem())
	mapScene.worldManager:addSystem(systemBuilder.getDrawSystem())
	mapScene.worldManager:addSystem(systemBuilder.getRoundSystem())
	mapScene.worldManager:ecsInit()

	local mob = Filesystem:loadMob("snake")
	
end

function mapScene.update(dt)
	if (Input:isActionPressed("EXIT")) then
		love.event.quit()
	end

	mapScene.UI:update(dt)

	if (Input:isActionDown("UP")) then
		MainCamera:setPosition(0, dt * -500)		 
	end

	if (Input:isActionDown("DOWN")) then
		MainCamera:setPosition(0, dt * 500)		
	end

	if (Input:isActionDown("LEFT")) then
		MainCamera:setPosition(dt * -500, 0)		
	end

	if (Input:isActionDown("RIGHT")) then
		MainCamera:setPosition(dt * 500, 0) 		
	end

	if (Input:isActionPressed("DEBUG_WALLS")) then
		mapScene.tilemapRenderer:toggleLayerVisibility("Data")
	end 

	if (Input:isActionPressed("CONSOLE")) then
	local textbox = mapScene.UI:getWidget(CONST_WIDGET_UI_TEXTBOX)
	local currentFocus = textbox:getFocus()
	textbox:setFocus(IIF(currentFocus == true, false, true))
	end 

	mapScene.worldManager:update(dt)
	-- if (mainRoom.input:IsActionDown("ZOOM")) then
	--     GameplayCamera.Zoom = GameplayCamera.Zoom + dt 
	-- end
	
end

function mapScene.draw()

	love.graphics.setBackgroundColor(0,0,0,1)
	
	local world = mapScene.worldManager
	-- Gameplay rendering
	MainCamera:beginDraw()
		mapScene.tilemapRenderer:draw()
		mapScene.tilemapRenderer.drawWorldWalls(world.gridWidth, world.gridHeight, world.tileWidth, world.tileHeight, world.gridData)		
		mapScene.worldManager:draw()
	MainCamera:endDraw()
	
	-- UI rendering    
	UICamera:beginDraw()
		Debug:drawStats()
		mapScene.UI:draw()
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

end

return mapScene