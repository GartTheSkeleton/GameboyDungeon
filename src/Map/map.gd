class_name Map
extends Node2D

@export var map_width: int = 80
@export var map_height: int = 45

var map_data: MapData


func _ready() -> void:
	var tilesAsNodes: Array[Node] = get_tree().get_nodes_in_group("room")
	map_data = MapData.new(map_width, map_height, tilesAsNodes)
