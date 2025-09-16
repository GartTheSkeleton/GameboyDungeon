class_name EventHandler
extends Node

@onready var game: Game = $".."

func get_action() -> Action:
	var action: Action = null
	if Input.is_action_just_pressed("Up"):
		var facing = game.playerFacing
		action = MovementAction.new(facing.x, facing.y)
	elif Input.is_action_just_pressed("Left"):
		action = TurnAction.new("Left", game)
	elif Input.is_action_just_pressed("Right"):
		action = TurnAction.new("Right", game)
		SignalBus.player_turned.emit(action.playerFacing)
	elif Input.is_action_just_pressed("B"):
		action = AttackAction.new()
	elif Input.is_action_just_pressed("A"):
		action = InteractAction.new()
	
	if Input.is_action_just_pressed("ui_cancel"):
		action = EscapeAction.new()
	
	return action
