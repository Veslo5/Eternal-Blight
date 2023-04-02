local roundSystem = {}

function roundSystem.getSystem()
	local system = Ecs.sortedProcessingSystem()
	system.name = "Round"
	system.roundSystem = true
	system.filter = Ecs.requireAll("ISimulated", "Stats")

	function system:compare(entity1, entity2)
		return entity1.Stats.defaultActionPoints > entity2.Stats.defaultActionPoints
	end

	function system:process(entity, dt)
		if entity.ISimulated.onTurn == false then
			entity.ISimulated.onTurn = true
		end

		Debug:log("Simulating" .. entity.name)
		-- TODO: Simulate AI?		
	end

	return system
end

return roundSystem