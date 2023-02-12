local SystemBuilder = {}

function SystemBuilder.GetDrawSystem()
	local system = Ecs.processingSystem()
	system.Name = "Draw"
	system.DrawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:process(entity, dt)
		love.graphics.setColor(0,1,0,1)
		love.graphics.rectangle("fill", entity.IDrawable.WorldX * 32, entity.IDrawable.WorldY * 32, 32, 32)
		love.graphics.setColor(1,1,1,1)
	end
	return system
end

function SystemBuilder.GetMoveSystem()
	local system = Ecs.processingSystem()
	system.Name = "Move"
	system.UpdateSystem = true
	system.filter = Ecs.requireAll("IGridMovable", "IControllable")

	function system:process(entity, dt)
		if(entity.IControllable.OnTurn == true and entity.IControllable.Possesed == true) then
			if (Input:IsActionPressed("MOVE_RIGHT")) then
				entity.IGridMovable.GridX = entity.IGridMovable.GridX + 1
				entity.IControllable.OnTurn = false
				entity.WorldManager:NextRound()
			end

			-- if (Input:IsActionPressed("LEFT")) then
			-- 	entity.IControllable.OnTurn = false
			-- 	entity.WorldManager:NextRound()
			-- end

			-- if (Input:IsActionPressed("UP")) then
			-- 	entity.IControllable.OnTurn = false
			-- 	entity.WorldManager:NextRound()
			-- end

			-- if (Input:IsActionPressed("DOWN")) then
			-- 	entity.IControllable.OnTurn = false
			-- 	entity.WorldManager:NextRound()
			-- end
		end
	end

	return system
end


function SystemBuilder.GetRoundSystem()
	local system = Ecs.processingSystem()
	system.Name = "Round"
	system.RoundSystem = true
	system.filter = Ecs.requireAll("ISimulated")

	function system:process(entity, dt)
	end

	return system
end

return SystemBuilder
