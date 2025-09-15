extends AnimatedSprite2D

@onready var gameworld = get_parent().get_parent()

func _process(delta: float) -> void:
	#print("I AM A COMPASS AND THE PLAYER IS FACING " + gameworld.playerFacingString)
	if animation != gameworld.playerFacingString:
		play(gameworld.playerFacingString)
