extends AnimatedSprite2D

@onready var gameworld = get_parent().get_parent()
@onready var healthLabel = $Control/HealthLabel
@onready var ammoLabel = $Control/AmmoLabel2
@onready var gun = $"../Gun"

var currentRoom = Vector2(0,0)

func _process(delta: float) -> void:
	if animation != gameworld.playerFacingString:
		play(gameworld.playerFacingString)
	healthLabel.text = "HP:" + str(gameworld.player.fighter_component.hp) + "/" + str(gameworld.player.fighter_component.max_hp)
	ammoLabel.text = str(gameworld.player.fighter_component.stored_ammo)
	
