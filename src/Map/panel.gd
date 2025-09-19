class_name BackgroundPanel
extends Sprite2D

var _definition: PanelDefinition
var is_locked: bool
var panel_name: String


func _init(grid_position: Vector2i, panel_definition: PanelDefinition) -> void:
	centered = false
	set_panel_type(panel_definition)


func set_panel_type(panel_definition: PanelDefinition) -> void:
	_definition = panel_definition
	texture = _definition.texture
	is_locked = _definition.locked
	panel_name = _definition.name
	
