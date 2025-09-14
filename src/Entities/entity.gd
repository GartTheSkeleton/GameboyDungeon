class_name Entity
extends Sprite2D

var definition: EntityDefinition
var fighter_component: FighterComponent
var blocks_movement: bool

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

func _init(start_position: Vector2i, entity_definition: EntityDefinition) -> void:
	centered = true
	grid_position = start_position
	set_entity_type(entity_definition)

func set_entity_type(entity_definition: EntityDefinition) -> void:
	definition = entity_definition
	blocks_movement = definition.is_blocking_movement
	texture = entity_definition.texture
	if entity_definition.fighter_definition:
		fighter_component = FighterComponent.new(entity_definition.fighter_definition)
		add_child(fighter_component)

func get_entity_name() -> String:
	return definition.name

func is_blocking_movement() -> bool:
	return blocks_movement

func is_alive() -> bool:
	return fighter_component && fighter_component.hp > 0
