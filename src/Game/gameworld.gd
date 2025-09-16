class_name Game
extends Node2D

signal player_created(player)

var directions = {
	"NORTH": Vector2i.UP, 
	"EAST": Vector2i.RIGHT, 
	"SOUTH": Vector2i.DOWN, 
	"WEST": Vector2i.LEFT
}

var playerFacing: Vector2i = directions["NORTH"]
var playerFacingString: String = directions.find_key(playerFacing)

@onready var camera: Camera2D = $Camera2D
@onready var event_handler: EventHandler = $EventHandler
@onready var entities: Node2D = $Entities
@onready var map: Map = $Map

@onready var player: Entity

var currentRoom: Tile
var rng = RandomNumberGenerator.new()
const entity_types = {
	"cyclops": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_cyclops.tres"),
	"player": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_player.tres"),
	"key": preload("res://src/Assets/Definitions/Entities/Items/entity_definition_key.tres"),
	"charm": preload("res://src/Assets/Definitions/Entities/Items/entity_definition_charm.tres")
}

func _ready() -> void:
	populate_map()

func _physics_process(_delta: float) -> void:
	var action: Action = event_handler.get_action()
	if action:
		await action.perform(self, player)
		var blocking_entity_in_room = get_map_data().get_blocking_entity_at_location(player.grid_position)
		if blocking_entity_in_room:
			var message: String
			if blocking_entity_in_room.entity_name == "Cyclops":
				message = "AHH! A Cyclops!"
			else:
				message = "You found a %s!" % blocking_entity_in_room.entity_name
			MessageLog.send_message(message)

func get_map_data() -> MapData:
	return map.map_data

func populate_map() -> void:
	rng.randomize()
	var map_data = get_map_data()
	var player_start_pos: Vector2i = Vector2i.ZERO
	player = Entity.new(player_start_pos, entity_types.player, map_data)
	player.position = player_start_pos
	map_data.player = player
	remove_child(camera)
	player.add_child(camera)
	entities.add_child(player)
	player_created.emit(player)
	for room in map_data.tiles:
		var random_chance = rng.randf_range(0, 10.0)
		if random_chance > 7.5 && room.gridPosition != Vector2i.ZERO:
			var npc := Entity.new(room.gridPosition, entity_types.cyclops, map_data)
			npc.position.y -= 6
			entities.add_child(npc)
			map_data.entities.append(npc)
		elif random_chance < 3 && room.gridPosition != Vector2i.ZERO:
			var item := Entity.new(room.gridPosition, entity_types.charm, map_data)
			item.position.y -= 6
			entities.add_child(item)
			map_data.entities.append(item)
	SignalBus.player_turned.emit(playerFacing)
