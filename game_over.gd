extends Node2D

@onready var grave = $Grave
@onready var text = $Text
@onready var return2title = $Return
var titlescreen = preload("res://src/Game/title_screen.tscn")

var timer = 160

func _process(delta: float) -> void:
	if grave.position.y < 90:
		grave.position.y += 80*delta
	else:
		grave.position.y = 90
		if grave.animation != "Animate":
			grave.play("Animate")
		if text.animation != "Animate":
			text.play("Animate")
		timer -= 1
		if timer <= 0:
			if return2title.animation != "Visible":
				return2title.play("Visible")
	
	if Input.is_action_just_pressed("A"):
		if return2title.animation == "Visible":
			var time2startover = titlescreen.instantiate()
			add_sibling(time2startover)
			queue_free()
