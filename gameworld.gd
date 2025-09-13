extends Node2D

var playerPosition = Vector2(0,0)
var playerFacing = "North"

@onready var readout = $Readout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	readout.text = "Player is in room " + str(playerPosition) + ", and is facing " + playerFacing
	
	if Input.is_action_just_pressed("Up"):
		move_player()
	if Input.is_action_just_pressed("Left"):
		turn_player("Left")
	if Input.is_action_just_pressed("Right"):
		turn_player("Right")


func turn_player(turnDirection):
	match turnDirection:
		"Left":
			match playerFacing:
				"North":
					playerFacing = "West"
				"West":
					playerFacing = "South"
				"South":
					playerFacing = "East"
				"East":
					playerFacing = "North"
		"Right":
			match playerFacing:
				"North":
					playerFacing = "East"
				"West":
					playerFacing = "North"
				"South":
					playerFacing = "West"
				"East":
					playerFacing = "South"
	

func move_player():
	match playerFacing:
		"North":
			playerPosition.y += 1
		"South":
			playerPosition.y -= 1
		"East":
			playerPosition.x += 1
		"West":
			playerPosition.x -= 1
