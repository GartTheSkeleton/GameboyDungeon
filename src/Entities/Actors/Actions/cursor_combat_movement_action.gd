class_name CursorCombatMovementAction
extends Action

var direction: String

func _init(direction: String) -> void:
	self.direction = direction



func perform(game: Game, entity: Entity) -> void:
	var combat_menu = game.combat_menu
	var cursor = combat_menu.cursor
	var cursor_parent = cursor.get_parent() as HBoxContainer
	var options = combat_menu.get_children() as Array[HBoxContainer]
	var current_index: int
	var removal_index = null
	for i in options.size():
		if !options[i].visible:
			removal_index = i
		if options[i].name == cursor_parent.name:
			current_index = i
	var next_index = null
	if removal_index:
		options.remove_at(removal_index)
	if direction == "Down":
		next_index = current_index + 1
		if next_index >= options.size():
			next_index = 0
	if direction == "Up":
		next_index = current_index - 1
		if next_index < 0:
			next_index = options.size() - 1

	var new_parent = options[next_index]
	cursor_parent.remove_child(cursor)
	new_parent.add_child(cursor)
	new_parent.move_child(cursor, 0)
