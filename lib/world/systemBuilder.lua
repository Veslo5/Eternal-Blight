local systemBuilder = {}

function systemBuilder.getDrawSystem()
	local system = Ecs.processingSystem()
	system.name = "Draw"
	system.drawSystem = true
	system.filter = Ecs.requireAll("IDrawable")

	function system:process(entity, dt)
		love.graphics.setColor(0,1,0,1)
		love.graphics.rectangle("fill", entity.IDrawable.worldX, entity.IDrawable.worldY, 32, 32)
		love.graphics.setColor(1,1,1,1)
	end
	return system
end

function systemBuilder.getMoveSystem()
	local system = Ecs.processingSystem()
	system.name = "Move"
	system.updateSystem = true
	system.filter = Ecs.requireAll("IGridMovable", "IControllable")

	function system:onAdd(entity)
		if entity.IDrawable then
			entity.IDrawable.worldX =  entity.IGridMovable.gridX * 32
			entity.IDrawable.worldY =  entity.IGridMovable.gridY * 32
		end
	end

	function system:process(entity, dt)
		if(entity.IControllable.onTurn == true and entity.IControllable.possesed == true) then
			local moved = false
			if (Input:isActionPressed("RIGHT")) then
				entity.IGridMovable.gridX = entity.IGridMovable.gridX + 1
				moved = true
			end

			if (Input:isActionPressed("LEFT")) then
				entity.IGridMovable.gridX = entity.IGridMovable.gridX - 1
				moved = true
			end

			if (Input:isActionPressed("UP")) then
				entity.IGridMovable.gridY = entity.IGridMovable.gridY - 1
				moved = true
			end

			if (Input:isActionPressed("DOWN")) then
				entity.IGridMovable.gridY = entity.IGridMovable.gridY+ 1
				moved = true
			end


			if moved then
				--TODO: uncomment
				--entity.IControllable.OnTurn = false
				
				if entity.IDrawable then
					entity.IDrawable.worldX =  entity.IGridMovable.gridX * 32
					entity.IDrawable.worldY =  entity.IGridMovable.gridY * 32
				end

				self.worldManager:nextRound()
			end

		end
	end

	return system
end


function systemBuilder.getRoundSystem()
	local system = Ecs.processingSystem()
	system.name = "Round"
	system.roundSystem = true
	system.filter = Ecs.requireAll("ISimulated")

	function system:process(entity, dt)
	end

	return system
end

return systemBuilder
