class_name Entity
extends Sprite2D

var definition: EntityDefinition

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
	texture = entity_definition.texture

func get_entity_name() -> String:
	return definition.name

func is_blocking_movement() -> bool:
	return definition.is_blocking_movement
