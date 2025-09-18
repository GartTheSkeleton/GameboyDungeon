class_name CombatInputHandler
extends BaseInputHandler

@onready var game: Game = %Gameworld

func get_action() -> Action:
	var action: Action = null
	if Input.is_action_just_pressed("Up"):
		action = CursorCombatMovementAction.new("Up")
	elif Input.is_action_just_pressed("Down"):
		action = CursorCombatMovementAction.new("Down")
	elif Input.is_action_just_pressed("A"):
		action = InteractAction.new(game.input_handler.current_input_handler_type)
	
	if Input.is_action_just_pressed("ui_cancel"):
		action = EscapeAction.new()
	
	return action
