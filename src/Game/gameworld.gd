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
@onready var readout = $Camera2D/Readout
@onready var event_handler: EventHandler = $EventHandler

func _process(delta: float) -> void:
	var action: Action = event_handler.get_action()
	
	if action is MovementAction:
		player_grid_pos += action.offset
		player.position = Grid.grid_to_world(player_grid_pos)
		print("position: ", player.position)
	if action is TurnAction:
		playerFacing = action.playerFacing
		playerFacingString = directions.find_key(playerFacing)
	elif action is EscapeAction:
		get_tree().quit()
	readout.text = "Player is in room " + str(player.position) + ", and is facing " + playerFacingString

#var playerPosition = Vector2(0,0)
#var playerFacing = "North"
#
#@onready var readout = $Readout
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#readout.text = "Player is in room " + str(playerPosition) + ", and is facing " + playerFacing
	#
	#if Input.is_action_just_pressed("Up"):
		#move_player()
	#if Input.is_action_just_pressed("Left"):
		#turn_player("Left")
	#if Input.is_action_just_pressed("Right"):
		#turn_player("Right")
#
#
#func turn_player(turnDirection):
	#match turnDirection:
		#"Left":
			#match playerFacing:
				#"North":
					#playerFacing = "West"
				#"West":
					#playerFacing = "South"
				#"South":
					#playerFacing = "East"
				#"East":
					#playerFacing = "North"
		#"Right":
			#match playerFacing:
				#"North":
					#playerFacing = "East"
				#"West":
					#playerFacing = "North"
				#"South":
					#playerFacing = "West"
				#"East":
					#playerFacing = "South"
	#
#
#func move_player():
	#match playerFacing:
		#"North":
			#playerPosition.y += 1
		#"South":
			#playerPosition.y -= 1
		#"East":
			#playerPosition.x += 1
		#"West":
			#playerPosition.x -= 1
