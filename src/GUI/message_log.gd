class_name MessageLog
extends Container

var last_message: Message

func _ready() -> void:
	SignalBus.message_sent.connect(add_message)
	SignalBus.remove_message.connect(clear_message)

func add_message(text: String) -> void:
	clear_message()
	var message := Message.new(text, GameColors.TEXT_COLOR)
	last_message = message
	add_child(message)
	await get_tree().process_frame

static func send_message(text: String) -> void:
	SignalBus.message_sent.emit(text)

static func remove_message() -> void:
	SignalBus.remove_message.emit()

func clear_message() -> void:
	if last_message:
		last_message.free()
		last_message = null
