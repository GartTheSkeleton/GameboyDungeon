extends AnimatedSprite2D

@onready var gameworld = get_parent().get_parent()
@onready var healthLabel = $Control/HealthLabel
@onready var ammoLabel = $Control/AmmoLabel
@onready var gun = $"../Gun"

var currentRoom = Vector2(0,0)

func _process(delta: float) -> void:
	print(gameworld.player.stored_ammo)
	if animation != gameworld.playerFacingString:
		play(gameworld.playerFacingString)
	healthLabel.text = "HP-" + str(gameworld.player.hp)
	
