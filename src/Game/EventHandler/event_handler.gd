class_name EventHandler
extends Node

@onready var game: Game = $".."
func get_action() -> Action:
	var action: Action = null
	if Input.is_action_just_pressed("Up"):
		var facing = game.playerFacing
		action = MovementAction.new(facing.x, facing.y)
	elif Input.is_action_just_pressed("Left"):
		print('facing: ', game.playerFacing)
		action = TurnAction.new("Left", game)
	elif Input.is_action_just_pressed("Right"):
		print('facing: ', game.playerFacing)
		action = TurnAction.new("Right", game)
	
	if Input.is_action_just_pressed("ui_cancel"):
		action = EscapeAction.new()
	
	return action
