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

const cyclops_definition: EntityDefinition = preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_cyclops.tres")

func _ready() -> void:
	var player_start_pos: Vector2i = Grid.world_to_grid(get_viewport_rect().size.floor() / 2)
	player.position = player_start_pos
	#var npc := Entity.new(player_start_pos, cyclops_definition)
	#entities.add_child(npc)
	SignalBus.player_turned.emit(playerFacing)

func _process(delta: float) -> void:
	var action: Action = event_handler.get_action()
	
	if action is MovementAction:
		player_grid_pos += action.offset
		player.position = Grid.grid_to_world(player_grid_pos)
		print("Player is in room " + str(player_grid_pos) + ", and is facing " + playerFacingString)
	if action is TurnAction:
		playerFacing = action.playerFacing
		playerFacingString = directions.find_key(playerFacing)
		print("Player is in room " + str(player_grid_pos) + ", and is facing " + playerFacingString)
		SignalBus.player_turned.emit(playerFacing)
	elif action is EscapeAction:
		get_tree().quit()
