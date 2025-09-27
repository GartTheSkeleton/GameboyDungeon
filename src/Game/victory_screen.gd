extends Node2D

@onready var outro = $Outro
@onready var outro2 = $Outro2
var outroTimer = 50
var titlescreen = load("res://src/Game/title_screen.tscn")
var state = 0
var endgame = false
var done = false
var timer = 0

func _ready() -> void:
	$AudioStreamPlayer2D.volume_db = -3
	$AudioStreamPlayer2D.play()

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= .03:
		timer = 0
		match state:
			0:
				if outro.visible_characters < outro.get_total_character_count():
					outro.visible_characters += 1
				else:
					outroTimer -= 1
					if outroTimer <= 0:
						state = 1
						outroTimer = 50
			1:
				outro.visible = false
				if outro2.visible_characters < outro2.get_total_character_count():
					outro2.visible_characters += 1
				else:
					outroTimer -= 1
					if outroTimer <= 0:
						state = 2
						outroTimer = 50
			2:
				if Input.is_action_just_pressed("A"):
					endgame = true
				

	if endgame == true:
		if Input.is_action_just_pressed("A"):
			var time2startover = titlescreen.instantiate()
			add_sibling(time2startover)
			
			queue_free()
