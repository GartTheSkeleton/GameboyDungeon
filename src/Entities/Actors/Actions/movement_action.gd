class_name MovementAction
extends Action

var offset: Vector2i

func _init(dx: int, dy: int) -> void:
	offset = Vector2i(dx, dy)

func perform(game: Game, entity: Entity) -> void:
	var current_grid_position = entity.grid_position
	var destination: Vector2i = current_grid_position + offset
	var map_data: MapData = game.get_map_data()
	var destination_tile: Tile = map_data.get_tile(destination)
	var current_room = map_data.get_tile(current_grid_position)
	var is_facing_wall: bool = false
	var blocking_enemy = game.get_map_data().get_blocking_entity_at_location(current_grid_position)
	
	match game.playerFacingString:
		"NORTH":
			if current_room.northPanelType == current_room.panelTypes.WALL:
				is_facing_wall = true
		"EAST":
			if current_room.eastPanelType == current_room.panelTypes.WALL:
				is_facing_wall = true
		"SOUTH":
			if current_room.southPanelType == current_room.panelTypes.WALL:
				is_facing_wall = true
		"WEST":
			if current_room.westPanelType == current_room.panelTypes.WALL:
				is_facing_wall = true
	if not destination_tile || is_facing_wall || blocking_enemy:
		print("blocking_enemy", blocking_enemy)
		return
	entity.grid_position = destination
