class_name CombatManager
extends Node2D

@export var player_character: Entity
@export var enemy_character: Entity

var current_character: Entity
var rng = RandomNumberGenerator.new()
var has_begun = false

func _ready() -> void:
	SignalBus.end_combat.connect(end_combat)

func begin_combat(player: Entity, enemy: Entity) -> void:
	rng.randomize()
	player_character = player
	enemy_character = enemy
	var player_init = randf_range(1, 6) + player.fighter_component.luck
	var enemy_init = randf_range(1, 6) + enemy.fighter_component.luck
	if player_init > enemy_init:
		current_character = player_character
	else:
		current_character = enemy_character
	visible = true
	has_begun = true
	begin_turn()

func next_turn() -> void:
	if !has_begun:
		return
	if current_character != null:
		end_turn()
	if current_character == enemy_character || current_character == null:
		current_character = player_character
	else:
		current_character = enemy_character
	begin_turn()

func begin_turn() -> void:
	#print("current_character", current_character)
	if current_character == player_character:
		#print("player turn!")
		pass
	else:
		#print("enemy turn!")
		var wait_time = randf_range(0.5, 1.5)
		await get_tree().create_timer(wait_time).timeout
#		cast combat action
		await get_tree().create_timer(0.5).timeout
	next_turn()

func end_turn() -> void:
	return

func end_combat() -> void:
	player_character = null
	enemy_character = null
	has_begun = false
	visible = false
	InputHandler.external_transition_to(InputHandler.InputHandlers.MAIN_GAME)
