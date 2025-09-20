class_name Entity
extends Node2D

var definition: EntityDefinition
var map_data: MapData
var fighter_component: FighterComponent
var item_component: ItemComponent
var entity_name: String
var is_mimic: bool
var blocks_movement: bool
var sprite: Sprite2D
var animated_sprite: AnimatedSprite2D
var is_fairy: bool = false

var texture: Texture:
	set(value):
		if sprite:
			sprite.texture = value

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

func _init(start_position: Vector2i, entity_definition: EntityDefinition, game_map_data: MapData, contents = null) -> void:
	if entity_definition.texture:
		sprite = Sprite2D.new()
		sprite.centered = true
		add_child(sprite)
	map_data = game_map_data
	grid_position = start_position
	set_entity_type(entity_definition, contents)

func set_entity_type(entity_definition: EntityDefinition, contents = null) -> void:
	definition = entity_definition
	entity_name = definition.name
	is_mimic = definition.is_mimic
	blocks_movement = definition.is_blocking_movement
	if entity_definition.texture:
		texture = entity_definition.texture
	if entity_definition.item_definition:
		item_component = ItemComponent.new(entity_definition.item_definition, contents)
		add_child(item_component)
	if entity_definition.fighter_definition:
		fighter_component = FighterComponent.new(entity_definition.fighter_definition, self)
		add_child(fighter_component)
	if entity_definition.is_fairy:
		set_animated_sprite()

func get_entity_name() -> String:
	return entity_name

func is_blocking_movement() -> bool:
	return blocks_movement

func is_alive() -> bool:
	return fighter_component && fighter_component.hp > 0

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		 # Assuming 'global_array' is a global array holding references
		if map_data.entities.has(self):
			map_data.entities.erase(self)
			# Repeat for any other arrays that might contain this object

func set_animated_sprite() -> void:
	var animated_sprite = AnimatedSprite2D.new()
	add_child(animated_sprite)
	animated_sprite.position = grid_position
	var sprite_frames = SpriteFrames.new()
	animated_sprite.sprite_frames = sprite_frames
	var sprite_sheet_texture = load("res://src/Entities/Actors/Animations/fairy.png")

	var animation_name = "float"
	var hframes = 2
	var vframes = 0
	var total_frames_in_animation = 2
	var start_frame_index = 0

	sprite_frames.add_animation(animation_name)
	sprite_frames.set_animation_speed(animation_name, 5)
	sprite_frames.set_animation_loop(animation_name, true)

	for i in range(total_frames_in_animation):
		var frame_index_in_sheet = start_frame_index + i
		var x = (frame_index_in_sheet % hframes)
		var y = (frame_index_in_sheet / hframes)

		var frame_rect = Rect2(x * (sprite_sheet_texture.get_width() / hframes),
		0,
		sprite_sheet_texture.get_width() / hframes,
		0)

		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = sprite_sheet_texture
		atlas_texture.region = frame_rect

		sprite_frames.add_frame(animation_name, atlas_texture)

	animated_sprite.play(animation_name)
