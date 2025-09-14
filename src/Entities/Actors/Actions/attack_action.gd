class_name AttackAction
extends Action

func perform(game: Game) -> void:
	var destination: Vector2i = game.player_grid_pos
	var target: Entity = game.get_map_data().get_blocking_entity_at_location(destination)
	if not target:
		print("No one to shoot")
		return
	print("You shoot the %s, much to it's annoyance!" % target.get_entity_name())
