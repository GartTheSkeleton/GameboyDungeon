class_name InteractAction
extends Action

func perform(game: Game, entity: Entity) -> void:
	var map_data: MapData = game.get_map_data()
	var interactable_entity_names = ["Key", "Lucky Charm", "Chest"]
	var interactable_entity = map_data.get_item_at_location(entity.grid_position)
	if !interactable_entity:
		return
	interactable_entity.item_component.activate(interactable_entity)
