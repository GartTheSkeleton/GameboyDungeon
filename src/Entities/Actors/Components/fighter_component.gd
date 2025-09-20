class_name FighterComponent
extends Component

@onready var gun = get_tree().get_first_node_in_group("Gun")

signal hp_changed(hp, max_hp)
var parent: Entity
var next_hit_crits: bool = false
var turn_skipped: bool = false
var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		hp_changed.emit(hp, max_hp)
		if hp <= 0:
			die()
var defense: int
var power: int
var death_texture: Texture
var stored_ammo: int = 0:
	set(value):
		stored_ammo = value
		if parent.entity_name == "Player":
			SignalBus.stats_changed.emit(parent)
var luck: int:
	set(value):
		luck = value
		if parent.entity_name == "Player":
			SignalBus.stats_changed.emit(parent)
var ammo: int:
	set(value):
		ammo = value
		if parent.entity_name == "Player":
			SignalBus.stats_changed.emit(parent)
var charms: int:
	set(value):
		charms = value
		if parent.entity_name == "Player":
			SignalBus.stats_changed.emit(parent)

var last_combat_action: String
var rng = RandomNumberGenerator.new()
var turn_count: int = 0

func _init(definition: FighterComponentDefinition, parent: Entity) -> void:
	self.parent = parent
	max_hp = definition.max_hp
	hp = definition.max_hp
	power = definition.power
	luck = definition.luck
	ammo = definition.ammo
	stored_ammo = definition.stored_ammo
	charms = definition.charms
	death_texture = definition.death_texture

func heal(amount: int) -> int:
	if hp == max_hp:
		return 0
	var new_hp_value: int = hp + amount
	if new_hp_value > max_hp:
		new_hp_value = max_hp
	var amount_recovered: int = new_hp_value - hp
	hp = new_hp_value
	return amount_recovered

func take_damage(amount: int) -> void:
	hp -= amount

func expend_ammo() -> void:
	ammo -= 1

func reload() -> void:
	if ammo == 6:
		MessageLog.send_message("You don't need to reload!")
	elif stored_ammo > 0:
		gun.play("Reload")
		var missing_ammo = 6 - ammo
		stored_ammo -= missing_ammo
		ammo += missing_ammo
		var message = "You load up %s more shots" % str(missing_ammo)
		MessageLog.send_message(message)
	await get_tree().create_timer(1).timeout

func pray() -> void:
	rng.randomize()
	MessageLog.send_message("You pray to whoever is listening...")
	await get_tree().create_timer(1).timeout
	var result = rng.randi_range(0, 6)
	if result == 6:
		if next_hit_crits == false:
			next_hit_crits = true
			MessageLog.send_message("You feel blessed by whoever heard you!")
		else:
			var health_reward = .5 * max_hp
			hp += health_reward
			MessageLog.send_message("By their blessing, you feel invigorated!")
	elif result == 5:
		if hp != max_hp:
			var health_reward = .5 * max_hp
			hp += health_reward
			MessageLog.send_message("By some blessing, you feel invigorated!")
		else: 
			var reward = 2
			var empty_slots = 6 - ammo
			if empty_slots >= reward:
				ammo += reward
				MessageLog.send_message("Your gun suddenly feels 2 bullets heavier!")
			else:
				stored_ammo += 2
				MessageLog.send_message("You found 2 bullets in your pocket!")
	elif result == 4:
		if ammo < 6:
			ammo += 1
			MessageLog.send_message("Your gun suddenly feels 1 bullet heavier!")
		else:
			stored_ammo += 1
			MessageLog.send_message("You found an extra bullet in your pocket!")
	else:
		MessageLog.send_message("You fear the gods aren't listening!")
	await get_tree().create_timer(1).timeout

func get_screamed_at(target_roll: int) -> void:
	await get_tree().create_timer(1).timeout
	var message: String
	if target_roll >= 3:
		luck -= 1
		turn_skipped = true
		if parent.entity_name != "Player":
			message = "%s winces at the noise!" % parent.entity_name
		else:
			message = "You wince at the noise!"
		MessageLog.send_message(message)
	else:
		if parent.entity_name == "Player":
			message = "You steady your heart!"
		else:
			message = "%s seems unphased..." % parent.entity_name
		MessageLog.send_message(message)
	await get_tree().create_timer(1).timeout

func die() -> void:
	var death_message: String
	if get_map_data().player == entity:
		death_message = "You died!"
		SignalBus.player_died.emit()
	else:
		death_message = "%s is dead!" % entity.get_entity_name()
	MessageLog.send_message(death_message)
	if death_texture:
		entity.texture = death_texture
	entity.entity_name = "Remains of %s" % entity.entity_name
	entity.blocks_movement = false
	SignalBus.end_combat.emit()
	if entity.is_mimic:
		SignalBus.create_entity.emit(entity.item_component.contents, entity.grid_position)
