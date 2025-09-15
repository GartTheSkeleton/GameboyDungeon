class_name Game
extends Node2D

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
	"player": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_player.tres")
}

func _ready() -> void:
	rng.randomize()
	var map_data = get_map_data()
	var player_start_pos: Vector2i = Grid.world_to_grid(get_viewport_rect().size.floor() / 2)
	player = Entity.new(player_start_pos, entity_types.player, map_data)
	player.position = player_start_pos
	map_data.player = player
	remove_child(camera)
	player.add_child(camera)
	entities.add_child(player)
	for room in map_data.tiles:
		var random_chance = rng.randf_range(0, 10.0)
		if random_chance > 7.5:
			var npc := Entity.new(room.gridPosition, entity_types.cyclops, map_data)
			entities.add_child(npc)
			map_data.entities.append(npc)
	SignalBus.player_turned.emit(playerFacing)

func _physics_process(_delta: float) -> void:
	var action: Action = event_handler.get_action()
	if action:
		action.perform(self, player)
		print("Player is in room " + str(player.grid_position) + ", and is facing " + playerFacingString)

func get_map_data() -> MapData:
	return map.map_data
