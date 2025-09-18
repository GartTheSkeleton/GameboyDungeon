class_name FighterComponent
extends Component

signal hp_changed(hp, max_hp)
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
var death_color: Color
var stored_ammo = 0
var luck
var ammo
var charms

func _init(definition: FighterComponentDefinition) -> void:
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
