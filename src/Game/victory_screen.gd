extends Node2D

@onready var outro = $Outro
@onready var outro2 = $Outro2
var outroTimer = 90
var titleScreen = preload("res://src/Game/title_screen.tscn")
var waitTimer = 90

func _ready() -> void:
	$AudioStreamPlayer2D.play()

func _physics_process(delta: float) -> void:
	var ready = false
	outroTimer += delta
	if outroTimer >= .03:
		outroTimer = 0
		if outro.visible_characters < outro.get_total_character_count():
			outro.visible_characters += 1
		else:
			if waitTimer > 0:
				waitTimer -= 1
			else:
				outro.visible = false
				if outro2.visible_characters < outro2.get_total_character_count():
					outro2.visible_characters += 1
				else:
					ready = true
	if ready == true:
		if Input.is_action_just_pressed("A") or Input.is_action_just_pressed("B"):
			var title = titleScreen.instantiate()
			add_sibling(title)
			queue_free()
