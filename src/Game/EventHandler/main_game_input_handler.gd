class_name MainGameInputHandler
extends BaseInputHandler

@onready var game: Game = %Gameworld

func close_map_and_wait() -> void:
	SignalBus.close_map.emit()

func get_action() -> Action:
	var action: Action = null
	if Input.is_action_just_pressed("Up"):
		await close_map_and_wait()
		var facing = game.playerFacing
		action = MovementAction.new(facing.x, facing.y)
	elif Input.is_action_just_pressed("Left"):
		await close_map_and_wait()
		action = TurnAction.new("Left", game)
	elif Input.is_action_just_pressed("Right"):
		await close_map_and_wait()
		action = TurnAction.new("Right", game)
		SignalBus.player_turned.emit(action.playerFacing)
	elif Input.is_action_just_pressed("A"):
		await close_map_and_wait()
		action = InteractAction.new(game.input_handler.current_input_handler_type)
	elif Input.is_action_just_pressed("Start"):
		SignalBus.toggle_map.emit()

	
	return action
