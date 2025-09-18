class_name CombatMenu
extends VBoxContainer

@onready var shoot_option = $Shoot
@onready var reload_option = $Reload
@onready var scream_action = $Scream
@onready var pray_action = $Pray
@onready var stab_action = $Stab
@onready var cursor: Label = $Shoot/Cursor

func _ready() -> void:
	stab_action.visible = false

func get_selected_option() -> HBoxContainer:
	var cursor_parent = cursor.get_parent() as HBoxContainer
	var options = get_children() as Array[HBoxContainer]
	var current_index: int
	for i in options.size():
		if options[i].name == cursor_parent.name:
			current_index = i
	return options[current_index]
