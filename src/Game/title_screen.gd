extends Node2D

var game = preload("res://src/Game/gameworld.tscn")

@onready var logo1 = $Sprite2D
@onready var powerOnSound = $AudioStreamPlayer2D
@onready var song = $Song
@onready var titleScreen = $"Title Screen Panel"
@onready var enemySprite = $"Title Screen Panel/Enemy"
@onready var creditScreen = $Credits
@onready var pointer = $"Title Screen Panel/Label"
@onready var intro = $Intro
@onready var intro2 = $Intro2
@onready var introPanel = $IntroPanel
var loading = true
var waitTimer = 90
var waitTimer2 = 82
var enemyType : int
var enemyAnimationTimer = 100
var state = 0
var pointerPos = 1
var introTimer = 0
var startgame = false
var clicksound = false
var songplayed = false

func _ready() -> void:
	titleScreen.visible = false
	randomize()
	enemyType = [1,2,3].pick_random()

func _physics_process(delta: float) -> void:
	song.volume_db = .5
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
			if songplayed == false:
				song.play()
				songplayed = true
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
			if titleScreen.visible == true:
				click()
			if pointerPos == 1:
				pointerPos = 2
			else:
				pointerPos = 1
		if Input.is_action_just_pressed("A"):
			match pointerPos:
				1:
					startgame = true
					titleScreen.visible = false
		if startgame == false:
			match pointerPos:
				1:
					pointer.position.x = 24
				2:
					pointer.position.x = 118
		else:
			introCutscene(delta)
			#if intro.visible_characters < intro.get_total_character_count():
				#intro.visible_characters += 1
				#waitTimer = 90
			#else:
				#waitTimer -= 1
				#if introPanel.visible == false:
					#introPanel.visible = true
				#if waitTimer <= 0:
					#if intro2.visible_characters < intro2.get_total_character_count():
						#intro2.visible_characters += 1
						#waitTimer2 = 90
				#else:
					#waitTimer2 -= 1
					#if waitTimer2 <= 0:
						#ready = true
			#if ready == true:
				#var newgame = game.instantiate()
				#add_sibling(newgame)
				#queue_free()

func introCutscene(delta):
	var ready = false
	introTimer += delta
	if introTimer >= .03:
		introTimer = 0
		print("CLICK")
		if intro.visible_characters < intro.get_total_character_count():
			intro.visible_characters += 1
			waitTimer = 60
		elif intro2.visible_characters < intro2.get_total_character_count():
			waitTimer -= 1
			
			if waitTimer <= 0:
				if introPanel.visible == false:
					introPanel.visible = true
				intro2.visible_characters += 1
				waitTimer2 = 60
		else:
			waitTimer2 -= 1
			if waitTimer2 <= 0:
				ready = true
		if ready == true:
			var newgame = game.instantiate()
			add_sibling(newgame)
			queue_free()

func click():
	if clicksound == true:
		$Click.pitch_scale = [.9,1,1.1].pick_random()
		$Click.play()
	if clicksound == false:
		clicksound = true
	
	
