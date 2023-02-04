local mainRoom = {}

mainRoom.input = require("lib.bindMe")
mainRoom.cameraFactory = require("lib.camera")
mainRoom.tilemapRenderer = require("lib.tilemap.tilemapRenderer")
mainRoom.tilemapLoader = require("lib.tilemap.tilemapLoader")
mainRoom.worldManager = require("lib.world.worldManager")

function mainRoom.load()
	mainRoom.input:Bind("EXIT", "escape")

	mainRoom.input:Bind("UP", "w")
	mainRoom.input:Bind("DOWN", "s")
	mainRoom.input:Bind("LEFT", "a")
	mainRoom.input:Bind("RIGHT", "d")   
	
	mainRoom.input:Bind("MOVE_RIGHT", "right")   
	mainRoom.input:Bind("MOVE_LEFT", "left")   
	mainRoom.input:Bind("MOVE_UP", "up")   
	mainRoom.input:Bind("MOVE_DOWN", "down")
	
	mainRoom.input:Bind("DEBUG_WALLS", ";")
	
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

	local playerEntity = {
		IGridMovable = {
			GridX = 0,
			GrdiY = 0
		},
		IDrawable = {
			X = 0,
			Y = 0
		}
	}

	mainRoom.worldManager:AddEntity(playerEntity)
	local updateSystem = Ecs.processingSystem()
		function updateSystem:process(entity, dt)
			
		end
	mainRoom.worldManager:EcsInit()

end

function mainRoom.update(dt)

	if (mainRoom.input:IsActionPressed("EXIT")) then
		love.event.quit()
	end

	if (mainRoom.input:IsActionDown("UP")) then
		 GameplayCamera.VirtualY = GameplayCamera.VirtualY - dt * 500
	end

	if (mainRoom.input:IsActionDown("DOWN")) then
		GameplayCamera.VirtualY = GameplayCamera.VirtualY + dt * 500
	end

	if (mainRoom.input:IsActionDown("LEFT")) then
		GameplayCamera.VirtualX = GameplayCamera.VirtualX - dt * 500
	end

	if (mainRoom.input:IsActionDown("RIGHT")) then
		GameplayCamera.VirtualX = GameplayCamera.VirtualX + dt * 500
	end

	if (mainRoom.input:IsActionPressed("DEBUG_WALLS")) then
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
	mainRoom.input:KeyPressed(key, scancode, isrepeat)
end

function mainRoom.keyreleased(key, scancode)
	mainRoom.input:KeyRelease(key, scancode)

end

function mainRoom.mousepressed(x, y, button, istouch, presses)
	mainRoom.input:MousePressed(x, y, button, istouch, presses)

end

function mainRoom.mousereleased(x, y, button, istouch, presses)
	mainRoom.input:MouseReleased(x, y, button, istouch, presses)


end

function mainRoom.resize(width, height)

end

function mainRoom.unload()

end

return mainRoom