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
	definition = entity_definition
	texture = definition.texture
