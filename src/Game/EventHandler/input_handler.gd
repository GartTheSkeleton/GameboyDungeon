class_name InputHandler
extends Node

enum InputHandlers {MAIN_GAME, GAME_OVER, COMBAT}

@export var start_input_handler: InputHandlers

@onready var input_handler_nodes := {
	InputHandlers.MAIN_GAME: $MainGameInputHandler,
	InputHandlers.GAME_OVER: $GameOverInputHandler,
	InputHandlers.COMBAT: $CombatInputHandler
}

var current_input_handler: BaseInputHandler
var current_input_handler_type: InputHandlers

func _ready() -> void:
	SignalBus.transition_input_handler.connect(transition_to)
	transition_to(start_input_handler)


func get_action() -> Action:
	return current_input_handler.get_action()

func transition_to(input_handler: InputHandlers) -> void:
	if current_input_handler != null:
		current_input_handler.exit()
	current_input_handler = input_handler_nodes[input_handler]
	current_input_handler_type = input_handler
	current_input_handler.enter()

static func external_transition_to(input_handler: InputHandlers):
	SignalBus.transition_input_handler.emit(input_handler)
