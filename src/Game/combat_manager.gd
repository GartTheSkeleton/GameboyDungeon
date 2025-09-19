class_name CombatManager
extends Node2D

@export var player_character: Entity
@export var enemy_character: Entity
@onready var input_handler: InputHandler = %InputHandler
@onready var game: Game = %Gameworld

var current_character: Entity
var rng = RandomNumberGenerator.new()
var has_begun = false

func _ready() -> void:
	SignalBus.end_combat.connect(end_combat)
	SignalBus.player_turn_complete.connect(end_player_turn)

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
	has_begun = true
	begin_turn()

func _physics_process(delta: float) -> void:
	if has_begun && current_character == player_character:
		if !current_character.fighter_component.turn_skipped:
			var action: Action = input_handler.get_action()
			if action:
				if action is InteractAction:
					visible = false
					InputHandler.external_transition_to(InputHandler.InputHandlers.NO_INPUT)
				await action.perform(game, player_character)
		else:
			MessageLog.send_message("You're too stunned to act quickly!")
			await get_tree().create_timer(1).timeout
			end_player_turn()
	if !has_begun && input_handler.current_input_handler_type != InputHandler.InputHandlers.MAIN_GAME:
		InputHandler.external_transition_to(InputHandler.InputHandlers.MAIN_GAME)

func next_turn() -> void:
	if current_character.fighter_component.turn_skipped:
		current_character.fighter_component.turn_skipped = false
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
	if current_character == player_character:
		InputHandler.external_transition_to(InputHandler.InputHandlers.COMBAT)
		visible = true
	else:
		if !current_character.fighter_component.turn_skipped:
			var wait_time = randf_range(0.5, 1.5)
			await get_tree().create_timer(wait_time).timeout
	#		cast combat action
			MessageLog.send_message("THE MONSTER ATTACKS")
			await get_tree().create_timer(0.5).timeout
		next_turn()

func end_turn() -> void:
	return

func end_combat() -> void:
	player_character.fighter_component.turn_skipped = false
	player_character.fighter_component.luck = -3 + player_character.fighter_component.charms
	player_character = null
	enemy_character.fighter_component.turn_skipped = false
	enemy_character = null
	has_begun = false
	visible = false
	InputHandler.external_transition_to(InputHandler.InputHandlers.MAIN_GAME)

func end_player_turn() -> void:
	player_character.fighter_component.turn_skipped = false
	next_turn()
