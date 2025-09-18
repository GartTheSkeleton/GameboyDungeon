class_name AttackAction
extends Action

var rng = RandomNumberGenerator.new()

func perform(game: Game, entity: Entity) -> void:
	rng.randomize()
	var destination: Vector2i = entity.grid_position
	var target: Entity = game.get_map_data().get_actor_at_location(destination)
	if not target:
		return
	var die_1 = rng.randi_range(1, 6)
	var die_2 = rng.randi_range(1, 6)
	var attack_roll = die_1 + die_2 + entity.fighter_component.luck
	var damage: int = entity.fighter_component.power
	var attack_description: String = "you attack %s" % target.get_entity_name()
	if damage > 0:
		attack_description += " for %d hit points." % damage
		target.fighter_component.take_damage(damage)
	else:
		attack_description += " but does no damage."
	if target.is_alive():
		MessageLog.send_message(attack_description)
	#if entity.item_component && !entity.item_component.is_activated:
		#entity.item_component.activate(entity)
