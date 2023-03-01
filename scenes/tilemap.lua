local Tilemap = {}

Tilemap.UI = require("lib.ui.uiManager")
Tilemap.tilemapRenderer = require("lib.tilemap.tilemapRenderer")
Tilemap.tilemapLoader = require("lib.tilemap.tilemapLoader"):New()
Tilemap.worldManager = require("lib.world.worldManager")

function Tilemap.load()
	Input:Bind("DEBUG_WALLS", {"p"})
	
	Tilemap.Loader =  ResourceLoader:New()

	Tilemap.UI:Load(UICamera.VirtualResX, UICamera.VirtualResY)
	-- Tilemap.UI:AddConsola(CONST_WIDGET_UI_CONSOLA, 0,0,500,250, "left", "bottom")
	-- Tilemap.UI:AddTextBox(CONST_WIDGET_UI_TEXTBOX, 0,0,500,30, "left", "bottom")

	local tilemaploader = Tilemap.tilemapLoader

	tilemaploader:LoadMetadata(CONST_INIT_MAP)
	for _, tilemapImage in ipairs(tilemaploader:GetResources()) do
		-- adds resources to loading queue
		Tilemap.Loader:NewImage(tilemapImage.name, tilemapImage.image)
	end

	Tilemap.tilemapRenderer:LoadResources(tilemaploader.TilesetMetadata)
	Tilemap.tilemapRenderer:BakeLayers(tilemaploader.TileMapMetadata)

	local mapSizeX = tilemaploader.TileMapMetadata.width
	local mapSizeY = tilemaploader.TileMapMetadata.height
	local mapTileWidth = tilemaploader.TileMapMetadata.tilewidth
	local mapTileHeight = tilemaploader.TileMapMetadata.tileheight

	local currentAtlas = Tilemap.tilemapRenderer.TileSetAtlas


	Tilemap.worldManager:SetupMapData(mapSizeX, mapSizeY, mapTileWidth, mapTileHeight)
--	local customBatch = mainRoom.tilemapRenderer:AddSpriteBatch("Testik", true, currentAtlas.Texture, currentAtlas:GetAtlasQuadCount())	

	local dataTileGroup = tilemaploader:GetGroupLayer("Data")
	
	if(dataTileGroup ~= nil) then
	Tilemap.worldManager:SetupWalls(dataTileGroup)    
	end

-- Sandbox --------------------------------------------------
	local entityBuilder = require("lib.world.entityBuilder")
	local playerEntity = entityBuilder:New("Player")
	playerEntity:MakeGridMovable(1,1)
	playerEntity:MakeControllable(true, true)
	playerEntity:MakeDrawable()

	
	Tilemap.worldManager:AddEntity(playerEntity)

	local systemBuilder = require("lib.world.systemBuilder")

	Tilemap.worldManager:AddSystem(systemBuilder.GetMoveSystem())
	Tilemap.worldManager:AddSystem(systemBuilder.GetDrawSystem())
	Tilemap.worldManager:AddSystem(systemBuilder.GetRoundSystem())
	Tilemap.worldManager:EcsInit()

	local mob = Filesystem:LoadMob("snake")
	
end

function Tilemap.update(dt)
	if (Input:IsActionPressed("EXIT")) then
		love.event.quit()
	end

	Tilemap.UI:Update(dt)

	if (Input:IsActionDown("UP")) then
		MainCamera:SetPosition(0, dt * -500)		 
	end

	if (Input:IsActionDown("DOWN")) then
		MainCamera:SetPosition(0, dt * 500)		
	end

	if (Input:IsActionDown("LEFT")) then
		MainCamera:SetPosition(dt * -500, 0)		
	end

	if (Input:IsActionDown("RIGHT")) then
		MainCamera:SetPosition(dt * 500, 0) 		
	end

	if (Input:IsActionPressed("DEBUG_WALLS")) then
		Tilemap.tilemapRenderer:ToggleLayerVisibility("Data")
	end 

	if (Input:IsActionPressed("CONSOLE")) then
	local textbox = Tilemap.UI:GetWidget(CONST_WIDGET_UI_TEXTBOX)
	local currentFocus = textbox:GetFocus()
	textbox:SetFocus(IIF(currentFocus == true, false, true))
	end 

	Tilemap.worldManager:Update(dt)
	-- if (mainRoom.input:IsActionDown("ZOOM")) then
	--     GameplayCamera.Zoom = GameplayCamera.Zoom + dt 
	-- end
	
end

function Tilemap.draw()

	love.graphics.setBackgroundColor(0,0,0,1)
	
	local world = Tilemap.worldManager
	-- Gameplay rendering
	MainCamera:BeginDraw()
		Tilemap.tilemapRenderer:Draw()
		Tilemap.tilemapRenderer.DrawWorldWalls(world.GridWidth, world.GridHeight, world.TileWidth, world.TileHeight, world.GridData)		
		Tilemap.worldManager:Draw()
	MainCamera:EndDraw()
	
	-- UI rendering    
	UICamera:BeginDraw()
		Debug:DrawStats()
		Tilemap.UI:Draw()
	UICamera:EndDraw()
end

--#####CALLBACKS######
function Tilemap.keypressed(key, scancode, isrepeat)
	--Input:keypressed(key, scancode, isrepeat)
	Tilemap.UI:KeyPressed(key)
end

function Tilemap.resize(width, height)
	MainCamera:Resize(width,height)
	UICamera:Resize(width,height)
	Tilemap.UI:Resize(width,height)
end

function Tilemap.textinput(text)
	Tilemap.UI:TextInput(text)
end

function Tilemap.unload()

end

return Tilemap