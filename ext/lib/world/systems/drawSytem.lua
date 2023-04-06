local drawSystem = {}

function drawSystem.getSystem()
	local system = Ecs.processingSystem()
	system.name = "Draw"
	system.drawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:onAdd(entity)		
			entity.IDrawable.worldX = entity.tile.x * self.worldManager.grid.tileWidth
			entity.IDrawable.worldY = entity.tile.y * self.worldManager.grid.tileHeight			
	end

	function system:process(entity, dt)		
		if entity.IDrawable.image then 
			CurrentScene.drawPipeline.objectRenderer:drawAtlasQuad(entity.IDrawable.image, entity.IDrawable.currentState, entity.IDrawable.worldX, entity.IDrawable.worldY)			
		else
			CurrentScene.drawPipeline.objectRenderer:drawRectangle("fill", entity.IDrawable.worldX, entity.IDrawable.worldY, entity.IDrawable.color)			
		end
		love.graphics.setColor(1, 1, 1, 1)
	end

	return system
end

return drawSystem