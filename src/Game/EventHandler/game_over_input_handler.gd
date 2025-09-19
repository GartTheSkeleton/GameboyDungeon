class_name GameOverInputHandler
extends BaseInputHandler

@onready var game: Game = %Gameworld

func get_action() -> Action:
	var action: Action = null
	if Input.is_action_just_pressed("B"):
		action = EscapeAction.new()
		action.perform(game, game.player)
	return action
