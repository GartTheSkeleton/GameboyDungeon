extends Node2D

@onready var healthLabel = %HealthLabel
@onready var ammoLabel = %AmmoLabel2
@onready var gameworld = %Gameworld

func _process(delta: float) -> void:
	healthLabel.text = "HP:" + str(gameworld.player.fighter_component.hp) + "/" + str(gameworld.player.fighter_component.max_hp)
	ammoLabel.text = str(gameworld.player.fighter_component.stored_ammo)
