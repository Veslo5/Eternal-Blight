local systemBuilder = {}

function systemBuilder.getDrawSystem()
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

function systemBuilder.getMoveSystem()
	local system = Ecs.processingSystem()
	system.name = "Move"
	system.updateSystem = true
	system.filter = Ecs.requireAll("IGridMovable", "IControllable")

	function system:onAdd(entity)
		if entity.IDrawable then
			entity.IDrawable.worldX = entity.IGridMovable.gridX * self.worldManager.tileWidth
			entity.IDrawable.worldY = entity.IGridMovable.gridY * self.worldManager.tileHeight
		end
	end

	function system:process(entity, dt)
		if (entity.IControllable.onTurn == true and entity.IControllable.possesed == true) then
			local moved = false

			if (Input:isActionPressed("RIGHT")) then
				local newGridX = entity.IGridMovable.gridX + 1
				local tile = self.worldManager:getTile(newGridX, entity.IGridMovable.gridY)
				if tile then
					if tile.wall == false then
						entity.IGridMovable.gridX = newGridX
						moved = true
					end
				end
			end

			if (Input:isActionPressed("LEFT")) then
				local newGridX = entity.IGridMovable.gridX - 1
				local tile = self.worldManager:getTile(newGridX, entity.IGridMovable.gridY)
				if tile then
					if tile.wall == false then
						entity.IGridMovable.gridX = newGridX
						moved = true
					end
				end
			end

			if (Input:isActionPressed("UP")) then
				local newGridY = entity.IGridMovable.gridY - 1
				local tile = self.worldManager:getTile(entity.IGridMovable.gridX, newGridY)
				if tile then
					if tile.wall == false then
						entity.IGridMovable.gridY = newGridY
						moved = true
					end
				end
			end

			if (Input:isActionPressed("DOWN")) then
				local newGridY = entity.IGridMovable.gridY + 1
				local tile = self.worldManager:getTile(entity.IGridMovable.gridX, newGridY) 
				if tile then
					if tile.wall == false then
						entity.IGridMovable.gridY = newGridY
						moved = true
					end
				end
			end

			if moved then
				--TODO: uncomment
				entity.IControllable.OnTurn = false

				if entity.IDrawable then
					entity.IDrawable.worldX = entity.IGridMovable.gridX * self.worldManager.tileWidth
					entity.IDrawable.worldY = entity.IGridMovable.gridY * self.worldManager.tileHeight
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
