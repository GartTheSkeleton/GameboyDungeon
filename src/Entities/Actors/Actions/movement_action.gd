class_name MovementAction
extends Action

var offset: Vector2i

var victoryscreen = preload("res://src/Game/victory_screen.tscn")

func _init(dx: int, dy: int) -> void:
	offset = Vector2i(dx, dy)

func perform(game: Game, entity: Entity) -> void:
	var current_grid_position = entity.grid_position
	var destination: Vector2i = current_grid_position + offset
	var map_data: MapData = game.get_map_data()
	var destination_tile: Tile = map_data.get_tile(destination)
	var current_room = map_data.get_tile(current_grid_position)
	var is_facing_wall: bool = false
	var blocking_entity = map_data.get_blocking_entity_at_location(current_grid_position)
	var item_in_room = map_data.get_item_at_location(current_grid_position)
	var blocking_panel_types = [current_room.panelTypes.WALL, current_room.panelTypes.LOCKEDDOOR]
	var found_exit = false
	match game.playerFacingString:
		"NORTH":
			if blocking_panel_types.has(current_room.northPanelType):
				is_facing_wall = true
			if current_room.northPanelType == current_room.panelTypes.DOOR:
				entity.get_tree().get_first_node_in_group("AudioBus").door.play()
			if current_room.northPanelType == current_room.panelTypes.EXIT:
				found_exit = true
				var victory = victoryscreen.instantiate()
				entity.get_tree().get_first_node_in_group("Gameworld").add_sibling(victory)
				entity.get_tree().get_first_node_in_group("Gameworld").queue_free()
				MessageLog.send_message("You escaped! Victory!")
		"EAST":
			if blocking_panel_types.has(current_room.eastPanelType):
				is_facing_wall = true
			if current_room.eastPanelType == current_room.panelTypes.DOOR:
				entity.get_tree().get_first_node_in_group("AudioBus").door.play()
			if current_room.eastPanelType == current_room.panelTypes.EXIT:
				found_exit = true
				var victory = victoryscreen.instantiate()
				entity.get_tree().get_first_node_in_group("Gameworld").add_sibling(victory)
				entity.get_tree().get_first_node_in_group("Gameworld").queue_free()
				MessageLog.send_message("You escaped! Victory!")
		"SOUTH":
			if blocking_panel_types.has(current_room.southPanelType):
				is_facing_wall = true
			if current_room.southPanelType == current_room.panelTypes.DOOR:
				entity.get_tree().get_first_node_in_group("AudioBus").door.play()
			if current_room.southPanelType == current_room.panelTypes.EXIT:
				found_exit = true
				var victory = victoryscreen.instantiate()
				entity.get_tree().get_first_node_in_group("Gameworld").add_sibling(victory)
				entity.get_tree().get_first_node_in_group("Gameworld").queue_free()
				MessageLog.send_message("You escaped! Victory!")
		"WEST":
			if blocking_panel_types.has(current_room.westPanelType):
				is_facing_wall = true
			if current_room.westPanelType == current_room.panelTypes.DOOR:
				entity.get_tree().get_first_node_in_group("AudioBus").door.play()
			if current_room.westPanelType == current_room.panelTypes.EXIT:
				found_exit = true
				var victory = victoryscreen.instantiate()
				entity.get_tree().get_first_node_in_group("Gameworld").add_sibling(victory)
				entity.get_tree().get_first_node_in_group("Gameworld").queue_free()
				MessageLog.send_message("You escaped! Victory!")
	if not found_exit:
		if not destination_tile || is_facing_wall || blocking_entity:
			MessageLog.send_message("The way is blocked!")
			return
		MessageLog.remove_message()
		if item_in_room && item_in_room.item_component.conversation_complete && !item_in_room.item_component.is_activated:
			item_in_room.item_component.conversation_complete = false
			item_in_room.item_component.conversation_started = false
		entity.map_data.visit_tile(destination_tile)
	entity.grid_position = destination
	entity.get_tree().get_first_node_in_group("Transitions").play("Walk")
