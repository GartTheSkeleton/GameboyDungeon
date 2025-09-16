extends Node

signal player_died
signal player_turned(direction: Vector2i)
signal message_sent(text: String, color: Color)
signal remove_message
signal stats_changed
signal create_entity(name: String, position: Vector2i)
signal entity_created(position: Vector2i)
