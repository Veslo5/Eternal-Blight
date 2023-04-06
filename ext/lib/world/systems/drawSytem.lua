local drawSystem = {}

function drawSystem.getSystem()
	local system =  Ecs.sortedProcessingSystem()
	system.name = "Draw"
	system.drawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:compare(entity1, entity2)
		return entity1.IDrawable.zIndex < entity2.IDrawable.zIndex
	end

	function system:onAdd(entity)		
			entity.IDrawable.worldX = entity.tile.x * self.worldManager.grid.tileWidth + entity.IDrawable.offsetX
			entity.IDrawable.worldY = entity.tile.y * self.worldManager.grid.tileHeight + entity.IDrawable.offsetY
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