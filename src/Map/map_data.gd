class_name MapData
extends RefCounted

#in the future if we do map generation we can use width and height to determine the maximum size of the dungeon
var width: int
var height: int
var tiles: Array[Node]
var entities: Array[Entity]
var player: Entity

func _init(map_width: int, map_height: int, all_tiles: Array[Node]) -> void:
	width = map_width
	height = map_height
	tiles = all_tiles

func get_tile(grid_position: Vector2i) -> Tile:
	var index = tiles.find_custom(func(tile: Tile): return tile.gridPosition == grid_position)
	if index == -1:
		return null
	return tiles[index] as Tile

func get_entity_at_location(grid_position: Vector2i) -> Entity:
	var index = entities.find_custom(func(entity: Entity): return entity.grid_position == grid_position)
	if index == -1:
		return null
	return entities[index] as Entity

func get_blocking_entity_at_location(grid_position: Vector2i) -> Entity:
	for entity in entities:
		if entity.is_blocking_movement() and entity.grid_position == grid_position:
			return entity
	return null

func get_actors() -> Array[Entity]:
	var actors: Array[Entity] = []
	for entity in entities:
		if entity.is_alive():
			actors.append(entity)
	return actors

func get_item_at_location(grid_position: Vector2i) -> Entity:
	var item: Entity
	for entity in entities:
		if entity.grid_position == grid_position && entity.item_component && !entity.item_component.is_activated:
			item = entity
			break
	return item

func get_actor_at_location(location: Vector2i) -> Entity:
	for actor in get_actors():
		if actor.grid_position == location:
			return actor
	return null
