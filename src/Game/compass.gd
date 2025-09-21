extends AnimatedSprite2D

@onready var gameworld = %Gameworld

var currentRoom = Vector2(0,0)

func _process(delta: float) -> void:
	if animation != gameworld.playerFacingString:
		play(gameworld.playerFacingString)
