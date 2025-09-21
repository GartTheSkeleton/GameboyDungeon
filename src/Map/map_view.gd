class_name MapView
extends Node2D

var map_data: MapData

@onready var game: Game = %Gameworld
@onready var canvas: CanvasLayer = $"../../../../.."
@onready var panel: Panel = $"../../.."
var displayed_tiles: Array[Vector2i]
var player_icon: ColorRect = ColorRect.new()

#duplicating grid.gd logic cause i don't feel like making that dynamic
const tile_size = Vector2i(4, 4)

func grid_to_world(grid_pos: Vector2i) -> Vector2i:
	var world_pos: Vector2i = grid_pos * tile_size
	return world_pos

func world_to_grid(world_pos: Vector2i) -> Vector2i:
	var grid_pos: Vector2i = world_pos / tile_size
	return grid_pos

func _ready() -> void:
	canvas.visible = false
	player_icon.color = Color("45283c")
	player_icon.size = tile_size
	player_icon.z_index = 100
	add_child(player_icon)
	map_data = game.get_map_data()
	SignalBus.toggle_map.connect(toggle_visibility)
	SignalBus.close_map.connect(force_close)
	draw_map()
	SignalBus.room_discovered.connect(draw_map)

func _process(delta: float) -> void:
	var player_pos = grid_to_world(game.player.grid_position)
	player_icon.position = player_pos

func toggle_visibility() -> void:
	canvas.visible = !canvas.visible

func force_close() -> void:
	canvas.visible = false

func draw_map() -> void:
	var visited_tiles = map_data.visited_tiles
	for i in visited_tiles.size():
		var tile = visited_tiles[i]
		if !displayed_tiles.has(tile.gridPosition):
			var world_coordinates = grid_to_world(visited_tiles[i].gridPosition)
			var room_panel = Panel.new()
			room_panel.position = world_coordinates
			room_panel.size = tile_size
			var style_box = StyleBoxFlat.new()
			style_box.bg_color = GameColors.TEXT_COLOR
			style_box.border_color = GameColors.WORLD_COLOR
			room_panel.add_theme_stylebox_override("panel", style_box)
			var border_panel_types = [tile.panelTypes.WALL, tile.panelTypes.LOCKEDDOOR]
			if border_panel_types.has(tile.northPanelType):
				style_box.border_width_top = 1
			if border_panel_types.has(tile.southPanelType):
				style_box.border_width_bottom = 1
			if border_panel_types.has(tile.westPanelType):
				style_box.border_width_left = 1
			if border_panel_types.has(tile.eastPanelType):
				style_box.border_width_right = 1
			add_child(room_panel)
