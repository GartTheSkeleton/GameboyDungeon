extends Node2D

var game = preload("res://src/Game/gameworld.tscn")

@onready var logo1 = $Sprite2D
@onready var powerOnSound = $AudioStreamPlayer2D
@onready var titleScreen = $"Title Screen Panel"
@onready var enemySprite = $"Title Screen Panel/Enemy"
@onready var creditScreen = $Credits
@onready var pointer = $"Title Screen Panel/Label"
var loading = true
var waitTimer = 82
var enemyType : int
var enemyAnimationTimer = 100
var state = 0
var pointerPos = 1

func _ready() -> void:
	titleScreen.visible = false
	randomize()
	enemyType = [1,2,3].pick_random()

func _process(delta: float) -> void:
	if state == 0:
		if logo1.global_position.y < 72:
			logo1.global_position.y += 30*delta
		else:
			if loading == true:
				powerOnSound.play()
				loading = false
			else:
				if waitTimer <= 0:
					state = 1
					creditScreen.visible = true
					logo1.visible = false
					waitTimer = 120
				else:
					waitTimer -= 1
	elif state == 1:
		if waitTimer <= 0:
			state = 2
			creditScreen.visible = false
			titleScreen.visible = true
			waitTimer = 4
			if enemySprite.animation != str(enemyType):
				enemySprite.play(str(enemyType))
		else:
			waitTimer -= 1
	elif state == 2:
		if titleScreen.visible == true:
			if waitTimer <= 0:
				if $"Title Screen Panel/AnimatedSprite2D".visible == false:
					$"Title Screen Panel/AnimatedSprite2D".visible = true
					waitTimer = 8
				elif $"Title Screen Panel/Enemy".visible == false:
					enemySprite.visible = true
			else:
				waitTimer -= 1
		if enemySprite.visible == true:
			enemyAnimationTimer -= 1
			if enemyAnimationTimer <= 0:
				enemyAnimationTimer = [90,120,180,210].pick_random()
				enemySprite.play(str(enemyType)+"Atk")
		if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
			if pointerPos == 1:
				pointerPos = 2
			else:
				pointerPos = 1
		if Input.is_action_just_pressed("A"):
			match pointerPos:
				1:
					var newgame = game.instantiate()
					add_sibling(newgame)
					queue_free()
		match pointerPos:
			1:
				pointer.position.x = 24
			2:
				pointer.position.x = 118
