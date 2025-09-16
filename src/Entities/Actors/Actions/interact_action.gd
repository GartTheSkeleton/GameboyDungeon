class_name InteractAction
extends Action

func perform(game: Game, entity: Entity) -> void:
	var map_data = game.get_map_data()
	var interactable_entity_names = ["Key", "Lucky Charm", "Chest"]
	var interactable_entities: Array[Entity]
	for map_entity in map_data.entities:
		if map_entity.grid_position == entity.grid_position:
			print("NAME: ", map_entity.entity_name)
			if interactable_entity_names.has(map_entity.entity_name):
				interactable_entities.append(map_entity)
	if !interactable_entities || interactable_entities.size() == 0:
		return
	interactable_entities.sort_custom(func(a,b): return a.entity_name == "Chest")
	if interactable_entities[0].entity_name == "Chest":
		MessageLog.send_message("You open the Chest!")
	elif interactable_entities[0].entity_name == "Lucky Charm":
		interactable_entities[0].free()
		entity.luck += 1
		entity.charms += 1
		SignalBus.stats_changed.emit(entity)
		MessageLog.send_message("You feel luckier!")
