class_name InteractAction
extends Action

var action_queue: Array[Action]
var input_handler: InputHandler.InputHandlers

func _init(input_handler: InputHandler.InputHandlers) -> void:
	self.input_handler = input_handler

func perform(game: Game, entity: Entity) -> void:
	if input_handler == InputHandler.InputHandlers.MAIN_GAME:
		var map_data: MapData = game.get_map_data()
		var interactable_entity = map_data.get_item_at_location(entity.grid_position)
		if !interactable_entity:
			return
		interactable_entity.item_component.activate(interactable_entity)
	elif input_handler == InputHandler.InputHandlers.COMBAT:
		var selected_option = game.combat_menu.get_selected_option()
		print('selection: ', selected_option.name)
		match selected_option.name:
			"Shoot":
				var attack = AttackAction.new()
				attack.perform(game, entity)
			"Reload":
				entity.fighter_component.reload()
			"Scream":
				pass
			"Pray":
				entity.fighter_component.pray()
			"Stab":
				pass
