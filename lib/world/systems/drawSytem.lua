local drawSystem = {}

function drawSystem.getSystem()
	local system = Ecs.processingSystem()
	system.name = "Draw"
	system.drawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:process(entity, dt)
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.rectangle("fill", entity.IDrawable.worldX, entity.IDrawable.worldY, 32, 32)
		love.graphics.setColor(1, 1, 1, 1)
	end

	return system
end

return drawSystem