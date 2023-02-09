local SystemBuilder = {}

function SystemBuilder.GetDrawSystem()
	local system = Ecs.processingSystem()
	system.DrawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:process(entity, dt)
		--print("draw - fromprocess")
		love.graphics.setColor(0,1,0,1)
		love.graphics.rectangle("fill", 0, 0, 32, 32)
		love.graphics.setColor(1,1,1,1)
		
	end
	return system
end

function SystemBuilder.GetMoveSystem()
	local system = Ecs.processingSystem()
	system.filter = Ecs.requireAll("IGridMovable")

	function system:process(entity, dt)
		--print("update - fromprocess")
	end

	return system
end


return SystemBuilder
