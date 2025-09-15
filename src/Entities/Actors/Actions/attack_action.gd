class_name AttackAction
extends Action

func perform(game: Game, entity: Entity) -> void:
	var destination: Vector2i = entity.grid_position
	var target: Entity = game.get_map_data().get_actor_at_location(destination)
	if not target:
		print("No one to shoot")
		return
	var damage: int = entity.fighter_component.power
	var attack_description: String = "you attack %s" % target.get_entity_name()
	if damage > 0:
		attack_description += " for %d hit points." % damage
		print(attack_description)
		target.fighter_component.hp -= damage
	else:
		attack_description += " but does no damage."
		print(attack_description)
