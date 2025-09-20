class_name Tile
extends Node2D

enum panelTypes { DOOR, HALL, WALL, LOCKEDDOOR }
enum enemyTypes { SLUG, SKELETON, CYCLOPS, ABOMINATION }
enum itemTypes {AMMO, CHARM, KNIFE}

@onready var leftSprite: Sprite2D = $LeftPanel
@onready var centerSprite: Sprite2D = $CenterPanel
@onready var rightSprite: Sprite2D = $RightPanel

@export var gridPosition: Vector2i
@export var northPanelType: panelTypes
@export var eastPanelType: panelTypes
@export var southPanelType: panelTypes
@export var westPanelType: panelTypes

@export var hasChest: bool = false
@export var isMimic: bool = false
@export var itemType: itemTypes

@export var hasEnemy: bool = false
@export var enemyType: enemyTypes 

@export var hasFairy: bool = false

@export var hasLever: bool = false
@export var leverTarget: Vector2i


var centerDoorPanelDefinition = preload("res://src/Assets/Definitions/Panels/center_door_panel_definition.tres")
var centerLockedPanelDefinition = preload("res://src/Assets/Definitions/Panels/center_locked_panel_definition.tres")
var centerHallPanelDefinition = preload("res://src/Assets/Definitions/Panels/center_hallway_panel_definition.tres")
var centerWallPanelDefinition = preload("res://src/Assets/Definitions/Panels/center_wall_panel_definition.tres")
var leftDoorPanelDefinition = preload("res://src/Assets/Definitions/Panels/left_door_panel_definition.tres")
var leftLockedPanelDefinition = preload("res://src/Assets/Definitions/Panels/left_locked_panel_definition.tres")
var leftHallPanelDefinition = preload("res://src/Assets/Definitions/Panels/left_hallway_panel_definition.tres")
var leftWallPanelDefinition = preload("res://src/Assets/Definitions/Panels/left_wall_panel_definition.tres")
var leftOpenPanelDefinition = preload("res://src/Assets/Definitions/Panels/left_open_panel_definition.tres")
var rightDoorPanelDefinition = preload("res://src/Assets/Definitions/Panels/right_door_panel_definition.tres")
var rightLockedPanelDefinition = preload("res://src/Assets/Definitions/Panels/right_locked_panel_definition.tres")
var rightHallPanelDefinition = preload("res://src/Assets/Definitions/Panels/right_hallway_panel_definition.tres")
var rightWallPanelDefinition = preload("res://src/Assets/Definitions/Panels/right_wall_panel_definition.tres")
var rightOpenPanelDefinition = preload("res://src/Assets/Definitions/Panels/right_open_panel_definition.tres")

func _ready() -> void:
	SignalBus.player_turned.connect(update_room_sprites)
	position = Grid.grid_to_world(gridPosition)
	SignalBus.gameworld_ready.connect(populate_room)

func update_room_sprites(direction: Vector2i) -> void:
#	set center tile base on player direction and the rooms directional panel types
	match direction:
		Vector2i.UP:
#			center is north paneltype
			match northPanelType:
				panelTypes.DOOR:
					centerSprite.texture = centerDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					centerSprite.texture = centerLockedPanelDefinition.texture
				panelTypes.HALL:
					centerSprite.texture = centerHallPanelDefinition.texture
				panelTypes.WALL:
					centerSprite.texture = centerWallPanelDefinition.texture
			match westPanelType:
				panelTypes.DOOR:
					leftSprite.texture = leftDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					leftSprite.texture = leftLockedPanelDefinition.texture
				panelTypes.HALL:
					leftSprite.texture = leftOpenPanelDefinition.texture
				panelTypes.WALL:
					leftSprite.texture = leftWallPanelDefinition.texture
			match eastPanelType:
				panelTypes.DOOR:
					rightSprite.texture = rightDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					rightSprite.texture = rightLockedPanelDefinition.texture
				panelTypes.HALL:
					rightSprite.texture = rightOpenPanelDefinition.texture
				panelTypes.WALL:
					rightSprite.texture = rightWallPanelDefinition.texture
		Vector2i.RIGHT:
			match eastPanelType:
				panelTypes.DOOR:
					centerSprite.texture = centerDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					centerSprite.texture = centerLockedPanelDefinition.texture
				panelTypes.HALL:
					centerSprite.texture = centerHallPanelDefinition.texture
				panelTypes.WALL:
					centerSprite.texture = centerWallPanelDefinition.texture
			match northPanelType:
				panelTypes.DOOR:
					leftSprite.texture = leftDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					leftSprite.texture = leftLockedPanelDefinition.texture
				panelTypes.HALL:
					leftSprite.texture = leftOpenPanelDefinition.texture
				panelTypes.WALL:
					leftSprite.texture = leftWallPanelDefinition.texture
			match southPanelType:
				panelTypes.DOOR:
					rightSprite.texture = rightDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					leftSprite.texture = rightLockedPanelDefinition.texture
				panelTypes.HALL:
					rightSprite.texture = rightOpenPanelDefinition.texture
				panelTypes.WALL:
					rightSprite.texture = rightWallPanelDefinition.texture
		Vector2i.DOWN:
			match southPanelType:
				panelTypes.DOOR:
					centerSprite.texture = centerDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					centerSprite.texture = centerLockedPanelDefinition.texture
				panelTypes.HALL:
					centerSprite.texture = centerHallPanelDefinition.texture
				panelTypes.WALL:
					centerSprite.texture = centerWallPanelDefinition.texture
			match eastPanelType:
				panelTypes.DOOR:
					leftSprite.texture = leftDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					leftSprite.texture = leftLockedPanelDefinition.texture
				panelTypes.HALL:
					leftSprite.texture = leftOpenPanelDefinition.texture
				panelTypes.WALL:
					leftSprite.texture = leftWallPanelDefinition.texture
			match westPanelType:
				panelTypes.DOOR:
					rightSprite.texture = rightDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					rightSprite.texture = rightLockedPanelDefinition.texture
				panelTypes.HALL:
					rightSprite.texture = rightOpenPanelDefinition.texture
				panelTypes.WALL:
					rightSprite.texture = rightWallPanelDefinition.texture
		Vector2i.LEFT:
			match westPanelType:
				panelTypes.DOOR:
					centerSprite.texture = centerDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					centerSprite.texture = centerLockedPanelDefinition.texture
				panelTypes.HALL:
					centerSprite.texture = centerHallPanelDefinition.texture
				panelTypes.WALL:
					centerSprite.texture = centerWallPanelDefinition.texture
			match southPanelType:
				panelTypes.DOOR:
					leftSprite.texture = leftDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					leftSprite.texture = leftLockedPanelDefinition.texture
				panelTypes.HALL:
					leftSprite.texture = leftOpenPanelDefinition.texture
				panelTypes.WALL:
					leftSprite.texture = leftWallPanelDefinition.texture
			match northPanelType:
				panelTypes.DOOR:
					rightSprite.texture = rightDoorPanelDefinition.texture
				panelTypes.LOCKEDDOOR:
					rightSprite.texture = rightLockedPanelDefinition.texture
				panelTypes.HALL:
					rightSprite.texture = rightOpenPanelDefinition.texture
				panelTypes.WALL:
					rightSprite.texture = rightWallPanelDefinition.texture

func populate_room() -> void:
	var entity_name: String
	var chest_contents = null
	match itemType:
		itemTypes.AMMO:
			chest_contents = "Ammo"
		itemTypes.KNIFE:
			chest_contents = "Knife"
		itemTypes.CHARM:
			chest_contents = "Lucky Charm"
	if hasChest:
		if isMimic:
			entity_name = "Mimic"
		else:
			entity_name = "Chest"
	if hasEnemy:
		match enemyType:
			enemyTypes.CYCLOPS:
				entity_name = "Cyclops"
			enemyTypes.SKELETON:
				entity_name = "Skeleton"
			enemyTypes.SLUG:
				entity_name = "Slug"
			enemyTypes.ABOMINATION:
				entity_name = "Abomination"
	if entity_name:
		print("entity_name, position: ", entity_name, gridPosition)
		SignalBus.create_entity.emit(entity_name, gridPosition, chest_contents)
