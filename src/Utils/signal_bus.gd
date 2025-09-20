extends Node

signal player_died
signal player_turned(direction: Vector2i)
signal message_sent(text: String, color: Color)
signal remove_message
signal stats_changed
signal start_combat
signal end_combat
signal player_turn_complete
signal create_entity(name: String, position: Vector2i, contents)
signal entity_created(entity_grid_position: Vector2i, player_grid_position)
signal transition_input_handler(input_handler: InputHandler.InputHandlers)
signal gameworld_ready
signal reveal_stab_action
