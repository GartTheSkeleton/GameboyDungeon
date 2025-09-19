extends Node

signal player_died
signal player_turned(direction: Vector2i)
signal message_sent(text: String, color: Color)
signal remove_message
signal stats_changed
signal start_combat
signal end_combat
signal player_turn_complete
signal create_entity(name: String, position: Vector2i)
signal entity_created(position: Vector2i)
signal transition_input_handler(input_handler: InputHandler.InputHandlers)
signal gameworld_ready
