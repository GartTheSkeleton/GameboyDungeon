class_name AttackAction
extends Action


var rng = RandomNumberGenerator.new()


func perform(game: Game, entity: Entity, is_knife_attack: bool = false) -> void:
	rng.randomize()
	if entity.entity_name == "Player":
		if entity.fighter_component.ammo <= 0:
			MessageLog.send_message("You're out of ammo!")
			return
		var destination: Vector2i = entity.grid_position
		var target: Entity = game.get_map_data().get_actor_at_location(destination)
		if not target:
			return
		var die_1 = rng.randi_range(1, 6)
		var die_2 = rng.randi_range(1, 6)
		var attack_roll = die_1 + die_2 + entity.fighter_component.luck
		var attack_description: String
		var damage: int
		if attack_roll > 11 || entity.fighter_component.next_hit_crits:
			damage = 2 * floor(.666 * entity.fighter_component.power) if is_knife_attack else 2 * entity.fighter_component.power
			attack_description = "You deal a devastating blow to %s" % target.get_entity_name()
			entity.fighter_component.next_hit_crits = false
			if !is_knife_attack:
				entity.fighter_component.ammo -= 1
				entity.get_tree().get_first_node_in_group("Gun").play("Shoot")
		elif attack_roll >= 5:
			damage = floor(.666 * entity.fighter_component.power) if is_knife_attack else entity.fighter_component.power
			var type_index = rng.randi_range(0,1)
			var options = ["stab", "slash at"]
			var attack_selection = options[type_index]
			attack_description = "You %s %s!" % [attack_selection, target.get_entity_name()] if is_knife_attack else "You shoot %s!" % target.get_entity_name()
			if !is_knife_attack:
				entity.fighter_component.ammo -= 1
				entity.get_tree().get_first_node_in_group("Gun").play("Shoot")
		elif attack_roll > 2:
			if !is_knife_attack:
				attack_description = "Your gun jams!"
				entity.get_tree().get_first_node_in_group("Gun").play("Jam")
			else:
				attack_description = "Your blade pierces nought but air."
		else:
			if !is_knife_attack:
				attack_description = "You miss your shot!"
				entity.fighter_component.ammo -= 1
				entity.get_tree().get_first_node_in_group("Gun").play("Shoot")
			else:
				attack_description = "It's too quick! Your knife clashes with stone!"
		MessageLog.send_message(attack_description)
		await game.get_tree().create_timer(.75).timeout
		await target.fighter_component.take_damage(damage)
	else:
		entity.fighter_component.swap_texture("attack")
		var target: Entity = game.player
		var die_1 = rng.randi_range(1, 6)
		var die_2 = rng.randi_range(1, 6)
		var attack_roll = die_1 + die_2 + entity.fighter_component.luck
		var attack_description: String
		var damage: int
		if attack_roll > 11 || entity.fighter_component.next_hit_crits:
			damage = 2 * entity.fighter_component.power
			attack_description = "%s strikes you with terrifying force!" % entity.get_entity_name()
			entity.fighter_component.ammo -= 1
			entity.fighter_component.next_hit_crits = false
		elif attack_roll >= 5:
			damage = entity.fighter_component.power
			attack_description= "%s strikes you!" % entity.get_entity_name()
		elif attack_roll > 2:
			attack_description = "%s lashes out, but you dodge!" % entity.get_entity_name()
		else:
			attack_description = "%s flails clumsily!" % entity.get_entity_name()
		MessageLog.send_message(attack_description)
		await game.get_tree().create_timer(1).timeout
		await target.fighter_component.take_damage(damage)
		entity.fighter_component.swap_texture("idle")
