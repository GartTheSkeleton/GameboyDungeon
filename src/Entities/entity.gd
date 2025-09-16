class_name Entity
extends Node2D

var definition: EntityDefinition
var map_data: MapData
var fighter_component: FighterComponent
var item_component: ItemComponent
var entity_name: String
var is_mimic: bool
var blocks_movement: bool
var sprite: Sprite2D
var luck: int
var ammo: int
var charms: int

var texture: Texture:
	set(value):
		if sprite:
			sprite.texture = value

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

func _init(start_position: Vector2i, entity_definition: EntityDefinition, game_map_data: MapData) -> void:
	if entity_definition.texture:
		sprite = Sprite2D.new()
		sprite.centered = true
		add_child(sprite)
	map_data = game_map_data
	grid_position = start_position
	set_entity_type(entity_definition)

func set_entity_type(entity_definition: EntityDefinition) -> void:
	definition = entity_definition
	entity_name = definition.name
	is_mimic = definition.is_mimic
	blocks_movement = definition.is_blocking_movement
	if entity_definition.texture:
		texture = entity_definition.texture
	if entity_definition.item_definition:
		item_component = ItemComponent.new(entity_definition.item_definition, "Lucky Charm")
		add_child(item_component)
	if entity_definition.fighter_definition:
		fighter_component = FighterComponent.new(entity_definition.fighter_definition)
		add_child(fighter_component)
		luck = entity_definition.fighter_definition.luck
		ammo = entity_definition.fighter_definition.ammo
		charms = entity_definition.fighter_definition.charms

func get_entity_name() -> String:
	return entity_name

func is_blocking_movement() -> bool:
	return blocks_movement

func is_alive() -> bool:
	return fighter_component && fighter_component.hp > 0

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		 # Assuming 'global_array' is a global array holding references
		if map_data.entities.has(self):
			map_data.entities.erase(self)
			# Repeat for any other arrays that might contain this object
			
