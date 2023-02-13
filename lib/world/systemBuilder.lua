local SystemBuilder = {}

function SystemBuilder.GetDrawSystem()
	local system = Ecs.processingSystem()
	system.Name = "Draw"
	system.DrawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:process(entity, dt)
		love.graphics.setColor(0,1,0,1)
		love.graphics.rectangle("fill", entity.IDrawable.WorldX, entity.IDrawable.WorldY, 32, 32)
		love.graphics.setColor(1,1,1,1)
	end
	return system
end

function SystemBuilder.GetMoveSystem()
	local system = Ecs.processingSystem()
	system.Name = "Move"
	system.UpdateSystem = true
	system.filter = Ecs.requireAll("IGridMovable", "IControllable")

	function system:onAdd(entity)
		if entity.IDrawable then
			entity.IDrawable.WorldX =  entity.IGridMovable.GridX * 32
			entity.IDrawable.WorldY =  entity.IGridMovable.GridY * 32
		end
	end

	function system:process(entity, dt)
		if(entity.IControllable.OnTurn == true and entity.IControllable.Possesed == true) then
			local moved = false
			if (Input:IsActionPressed("MOVE_RIGHT")) then
				entity.IGridMovable.GridX = entity.IGridMovable.GridX + 1
				moved = true
			end

			if (Input:IsActionPressed("MOVE_LEFT")) then
				entity.IGridMovable.GridX = entity.IGridMovable.GridX - 1
				moved = true
			end

			if (Input:IsActionPressed("MOVE_UP")) then
				entity.IGridMovable.GridY = entity.IGridMovable.GridY - 1
				moved = true
			end

			if (Input:IsActionPressed("MOVE_DOWN")) then
				entity.IGridMovable.GridY = entity.IGridMovable.GridY+ 1
				moved = true
			end


			if moved then
				--TODO: uncomment
				--entity.IControllable.OnTurn = false
				
				if entity.IDrawable then
					entity.IDrawable.WorldX =  entity.IGridMovable.GridX * 32
					entity.IDrawable.WorldY =  entity.IGridMovable.GridY * 32
				end

				self.WorldManager:NextRound()
			end

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
