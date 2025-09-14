class_name Game
extends Node2D

var player_grid_pos := Vector2i.ZERO
var directions = {
	"NORTH": Vector2i.UP, 
	"EAST": Vector2i.RIGHT, 
	"SOUTH": Vector2i.DOWN, 
	"WEST": Vector2i.LEFT
}

var playerFacing: Vector2i = directions["NORTH"]
var playerFacingString: String = directions.find_key(playerFacing)

@onready var player: Camera2D = $Camera2D
@onready var event_handler: EventHandler = $EventHandler
@onready var entities: Node2D = $Entities
@onready var map: Map = $Map

var currentRoom: Tile
var rng = RandomNumberGenerator.new()
const entity_types = {
	"cyclops": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_cyclops.tres")
}

func _ready() -> void:
	rng.randomize()
	var player_start_pos: Vector2i = Grid.world_to_grid(get_viewport_rect().size.floor() / 2)
	player.position = player_start_pos
	var map_data = get_map_data()
	for room in map_data.tiles:
		var random_chance = rng.randf_range(0, 10.0)
		if random_chance > 7.5:
			var npc := Entity.new(room.gridPosition, entity_types.cyclops)
			entities.add_child(npc)
			map_data.entities.append(npc)
	SignalBus.player_turned.emit(playerFacing)

func _physics_process(_delta: float) -> void:
	var action: Action = event_handler.get_action()
	if action:
		action.perform(self)
		print("Player is in room " + str(player_grid_pos) + ", and is facing " + playerFacingString)

func get_map_data() -> MapData:
	return map.map_data
