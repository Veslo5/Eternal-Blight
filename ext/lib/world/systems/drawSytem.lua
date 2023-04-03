local drawSystem = {}

function drawSystem.getSystem()
	local system = Ecs.processingSystem()
	system.name = "Draw"
	system.drawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:process(entity, dt)
		love.graphics.setColor(entity.IDrawable.color)
		if entity.IDrawable.image then 
			love.graphics.draw(entity.IDrawable.image, entity.IDrawable.worldX, entity.IDrawable.worldY)
		else
			love.graphics.rectangle("fill", entity.IDrawable.worldX, entity.IDrawable.worldY, 32, 32)
		end
		love.graphics.setColor(1, 1, 1, 1)
	end

	return system
end

return drawSystem