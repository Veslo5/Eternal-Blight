local mainRoom = {}

mainRoom.cameraFactory = require("lib.camera")
mainRoom.tilemapRenderer = require("lib.tilemap.tilemapRenderer")
mainRoom.tilemapLoader = require("lib.tilemap.tilemapLoader")
mainRoom.worldManager = require("lib.world.worldManager")

function mainRoom.load()
	Input:Bind("EXIT", "escape")

	Input:Bind("UP", "w")
	Input:Bind("DOWN", "s")
	Input:Bind("LEFT", "a")
	Input:Bind("RIGHT", "d")   
	
	Input:Bind("MOVE_RIGHT", "right")   
	Input:Bind("MOVE_LEFT", "left")   
	Input:Bind("MOVE_UP", "up")   
	Input:Bind("MOVE_DOWN", "down")
	
	Input:Bind("DEBUG_WALLS", ";")
	
	GameplayCamera = mainRoom.cameraFactory:New()
	UiCamera = mainRoom.cameraFactory:New(100, "Fill", 1366, 768)

	local tilemaploader = mainRoom.tilemapLoader

	tilemaploader:LoadTileset("data/test_map001.lua")
	mainRoom.tilemapRenderer:LoadResources(tilemaploader.TilesetMetadata)
	mainRoom.tilemapRenderer:BakeLayers(tilemaploader.TileMapMetadata)

	local mapSizeX = tilemaploader.TileMapMetadata.width
	local mapSizeY = tilemaploader.TileMapMetadata.height
	local mapTileWidth = tilemaploader.TileMapMetadata.tilewidth
	local mapTileHeight = tilemaploader.TileMapMetadata.tileheight

	local currentAtlas = mainRoom.tilemapRenderer.TileSetAtlas


	mainRoom.worldManager:SetupMapData(mapSizeX, mapSizeY, mapTileWidth, mapTileHeight)
--	local customBatch = mainRoom.tilemapRenderer:AddSpriteBatch("Testik", true, currentAtlas.Texture, currentAtlas:GetAtlasQuadCount())	

	local dataTileGroup = tilemaploader:GetGroupLayer("Data")
	
	if(dataTileGroup ~= nil) then
	mainRoom.worldManager:SetupWalls(dataTileGroup)    
	end

-- Sandbox --------------------------------------------------
	local entityBuilder = require("lib.world.entityBuilder")
	local playerEntity = entityBuilder:New(mainRoom.worldManager, "Player")
	playerEntity:MakeGridMovable()
	playerEntity:MakeControllable(true, true)
	playerEntity:MakeDrawable()

	
	mainRoom.worldManager:AddEntity(playerEntity)

	local systemBuilder = require("lib.world.systemBuilder")

	mainRoom.worldManager:AddSystem(systemBuilder.GetMoveSystem())
	mainRoom.worldManager:AddSystem(systemBuilder.GetDrawSystem())
	mainRoom.worldManager:AddSystem(systemBuilder.GetRoundSystem())
	mainRoom.worldManager:EcsInit()
end

function mainRoom.update(dt)

	if (Input:IsActionPressed("EXIT")) then
		love.event.quit()
	end

	if (Input:IsActionDown("UP")) then
		 GameplayCamera.VirtualY = GameplayCamera.VirtualY - dt * 500
	end

	if (Input:IsActionDown("DOWN")) then
		GameplayCamera.VirtualY = GameplayCamera.VirtualY + dt * 500
	end

	if (Input:IsActionDown("LEFT")) then
		GameplayCamera.VirtualX = GameplayCamera.VirtualX - dt * 500
	end

	if (Input:IsActionDown("RIGHT")) then
		GameplayCamera.VirtualX = GameplayCamera.VirtualX + dt * 500
	end

	if (Input:IsActionPressed("DEBUG_WALLS")) then
		mainRoom.tilemapRenderer:ToggleLayerVisibility("Data")
	end 

	mainRoom.worldManager:Update(dt)
	-- if (mainRoom.input:IsActionDown("ZOOM")) then
	--     GameplayCamera.Zoom = GameplayCamera.Zoom + dt 
	-- end
	
end

function mainRoom.draw()

	love.graphics.setBackgroundColor(0,0,0,1)
	
	local world = mainRoom.worldManager
	-- Gameplay rendering
	GameplayCamera:BeginDraw()
		mainRoom.tilemapRenderer:Draw()
		mainRoom.tilemapRenderer.DrawWorldWalls(world.GridWidth, world.GridHeight, world.TileWidth, world.TileHeight, world.GridData)		
		mainRoom.worldManager:Draw()
	GameplayCamera:EndDraw()
	
	-- UI rendering    
	UiCamera:BeginDraw()
		Debug:DrawStats()
	UiCamera:EndDraw()
end

--#####CALLBACKS######
function mainRoom.keypressed(key, scancode, isrepeat)
	Input:KeyPressed(key, scancode, isrepeat)
end

function mainRoom.keyreleased(key, scancode)
	Input:KeyRelease(key, scancode)
end

function mainRoom.mousepressed(x, y, button, istouch, presses)
	Input:MousePressed(x, y, button, istouch, presses)
end

function mainRoom.mousereleased(x, y, button, istouch, presses)
	Input:MouseReleased(x, y, button, istouch, presses)
end

function mainRoom.resize(width, height)

end

function mainRoom.unload()

end

return mainRoom