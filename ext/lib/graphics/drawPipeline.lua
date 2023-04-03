local drawPipeline = {}

drawPipeline.tilemapRenderer = require("ext.lib.graphics.tilemapRenderer")
drawPipeline.objectRenderer = require("ext.lib.graphics.objectRenderer")

function drawPipeline:createTilemapRenderers(tiledMapMetadata, gridData, gridWidth, gridHeight, resources)	
	self.tilemapRenderer:createRenderers(tiledMapMetadata, resources)
	self.tilemapRenderer:createFogRenderer(table.find(resources, "name", "fog").value, gridData, gridWidth, gridHeight)
end

function drawPipeline:bakeFogData(gridData, gridWidth, gridHeight)
	self.tilemapRenderer:bakeFogData(gridData, gridWidth, gridHeight)
end



function drawPipeline:update(dt)
	
end

function drawPipeline:draw(worldManager, UI, loading)
	love.graphics.setBackgroundColor(0, 0, 0, 1)

	if loading == true then
		UICamera:beginDraw()
			love.graphics.print("Loading...", 0,0)
		UICamera:endDraw()
		return
	end

	-- Gameplay rendering
	MainCamera:beginDraw()
	do
		self.tilemapRenderer:beginDraw()
			worldManager:draw()
		self.tilemapRenderer:endDraw()

	end
	MainCamera:endDraw()

	-- UI rendering
	UICamera:beginDraw()
	do
		Debug:drawStats()
			UI:draw()
	end
	UICamera:endDraw()
end

function drawPipeline:unload()
	self.tilemapRenderer:unload()
	self.objectRenderer:unload()
end

return drawPipeline