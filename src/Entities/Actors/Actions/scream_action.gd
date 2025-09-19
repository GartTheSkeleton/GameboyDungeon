class_name ScreamAction
extends Action

var rng = RandomNumberGenerator.new()

func perform(game: Game, entity: Entity) -> void:
	if entity.entity_name == "Player":
		rng.randomize()
		var destination: Vector2i = entity.grid_position
		var target: Entity = game.get_map_data().get_actor_at_location(destination)
		if not target:
			return
		MessageLog.send_message("You let out a primal scream!")
		var result = rng.randi_range(0, 6) + entity.fighter_component.luck
		await target.fighter_component.get_screamed_at(result)
	else:
		rng.randomize()
		var target: Entity = game.player
		var message = "%s lets out a primal scream!" % entity.entity_name
		MessageLog.send_message(message)
		var result = rng.randi_range(0, 6) + entity.fighter_component.luck
		target.fighter_component.get_screamed_at(result)
