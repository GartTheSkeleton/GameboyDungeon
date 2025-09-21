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
	player_icon.color = GameColors.WORLD_COLOR
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
		if !displayed_tiles.has(visited_tiles[i]):
			var world_coordinates = grid_to_world(visited_tiles[i])
			var map_tile = ColorRect.new()
			map_tile.position = world_coordinates
			map_tile.size = tile_size
			map_tile.color = GameColors.TEXT_COLOR
			add_child(map_tile)
