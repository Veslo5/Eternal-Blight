local drawSystem = {}

function drawSystem.getSystem()
	local system = Ecs.processingSystem()
	system.name = "Draw"
	system.drawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:process(entity, dt)		
		if entity.IDrawable.image then 
			love.graphics.draw(entity.IDrawable.image, entity.IDrawable.worldX, entity.IDrawable.worldY)
		else
			CurrentScene.drawPipeline.objectRenderer:drawRectangle("fill", entity.IDrawable.worldX, entity.IDrawable.worldY, entity.IDrawable.color)			
		end
		love.graphics.setColor(1, 1, 1, 1)
	end

	return system
end

return drawSystem