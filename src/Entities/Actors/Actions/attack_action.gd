class_name AttackAction
extends Action

var rng = RandomNumberGenerator.new()

func perform(game: Game, entity: Entity) -> void:
	if entity.entity_name == "Player" && entity.fighter_component.ammo <= 0:
		MessageLog.send_message("You're out of ammo!")
		return
	rng.randomize()
	var destination: Vector2i = entity.grid_position
	var target: Entity = game.get_map_data().get_actor_at_location(destination)
	if not target:
		return
	var die_1 = rng.randi_range(1, 6)
	var die_2 = rng.randi_range(1, 6)
	var attack_roll = die_1 + die_2 + entity.fighter_component.luck
	var attack_description: String
	if attack_roll > 11 || entity.fighter_component.next_hit_crits:
		var damage: int = 2 * entity.fighter_component.power
		attack_description = "you attack %s" % target.get_entity_name()
		target.fighter_component.take_damage(damage)
		entity.fighter_component.ammo -= 1
		entity.fighter_component.next_hit_crits = false
	elif attack_roll >= 5:
		var damage: int = entity.fighter_component.power
		attack_description= "You attack %s" % target.get_entity_name()
		target.fighter_component.take_damage(damage)
		entity.fighter_component.ammo -= 1
	elif attack_roll > 1:
		attack_description = "Your gun jams!"
	else:
		attack_description = "You miss your shot!"
		entity.fighter_component.ammo -= 1
	if target.is_alive():
		MessageLog.send_message(attack_description)
	#if entity.item_component && !entity.item_component.is_activated:
		#entity.item_component.activate(entity)
