class_name Tile
extends Node2D

enum panelTypes { DOOR, HALL, WALL }

@onready var leftSprite: Sprite2D = $LeftPanel
@onready var centerSprite: Sprite2D = $CenterPanel
@onready var rightSprite: Sprite2D = $RightPanel

@export var gridPosition: Vector2i
@export var northPanelType: panelTypes
@export var eastPanelType: panelTypes
@export var southPanelType: panelTypes
@export var westPanelType: panelTypes

var centerDoorPanelDefinition = preload("res://src/Assets/Definitions/Panels/center_door_panel_definition.tres")
var centerHallPanelDefinition = preload("res://src/Assets/Definitions/Panels/center_hallway_panel_definition.tres")
var centerWallPanelDefinition = preload("res://src/Assets/Definitions/Panels/center_wall_panel_definition.tres")
var leftDoorPanelDefinition = preload("res://src/Assets/Definitions/Panels/left_door_panel_definition.tres")
var leftHallPanelDefinition = preload("res://src/Assets/Definitions/Panels/left_hallway_panel_definition.tres")
var leftWallPanelDefinition = preload("res://src/Assets/Definitions/Panels/left_wall_panel_definition.tres")
var rightDoorPanelDefinition = preload("res://src/Assets/Definitions/Panels/right_door_panel_definition.tres")
var rightHallPanelDefinition = preload("res://src/Assets/Definitions/Panels/right_hallway_panel_definition.tres")
var rightWallPanelDefinition = preload("res://src/Assets/Definitions/Panels/right_wall_panel_definition.tres")

func _ready() -> void:
	SignalBus.player_turned.connect(update_room_sprites)
	position = Grid.grid_to_world(gridPosition)

func update_room_sprites(direction: Vector2i) -> void:
#	set center tile base on player direction and the rooms directional panel types
	match direction:
		Vector2i.UP:
#			center is north paneltype
			match northPanelType:
				panelTypes.DOOR:
					centerSprite.texture = centerDoorPanelDefinition.texture
				panelTypes.HALL:
					centerSprite.texture = centerHallPanelDefinition.texture
				panelTypes.WALL:
					centerSprite.texture = centerWallPanelDefinition.texture
			match westPanelType:
				panelTypes.DOOR:
					leftSprite.texture = leftDoorPanelDefinition.texture
				panelTypes.HALL:
					leftSprite.texture = leftHallPanelDefinition.texture
				panelTypes.WALL:
					leftSprite.texture = leftWallPanelDefinition.texture
			match eastPanelType:
				panelTypes.DOOR:
					rightSprite.texture = rightDoorPanelDefinition.texture
				panelTypes.HALL:
					rightSprite.texture = rightHallPanelDefinition.texture
				panelTypes.WALL:
					rightSprite.texture = rightWallPanelDefinition.texture
		Vector2i.RIGHT:
			match eastPanelType:
				panelTypes.DOOR:
					centerSprite.texture = centerDoorPanelDefinition.texture
				panelTypes.HALL:
					centerSprite.texture = centerHallPanelDefinition.texture
				panelTypes.WALL:
					centerSprite.texture = centerWallPanelDefinition.texture
			match northPanelType:
				panelTypes.DOOR:
					leftSprite.texture = leftDoorPanelDefinition.texture
				panelTypes.HALL:
					leftSprite.texture = leftHallPanelDefinition.texture
				panelTypes.WALL:
					leftSprite.texture = leftWallPanelDefinition.texture
			match southPanelType:
				panelTypes.DOOR:
					rightSprite.texture = rightDoorPanelDefinition.texture
				panelTypes.HALL:
					rightSprite.texture = rightHallPanelDefinition.texture
				panelTypes.WALL:
					rightSprite.texture = rightWallPanelDefinition.texture
		Vector2i.DOWN:
			match southPanelType:
				panelTypes.DOOR:
					centerSprite.texture = centerDoorPanelDefinition.texture
				panelTypes.HALL:
					centerSprite.texture = centerHallPanelDefinition.texture
				panelTypes.WALL:
					centerSprite.texture = centerWallPanelDefinition.texture
			match eastPanelType:
				panelTypes.DOOR:
					leftSprite.texture = leftDoorPanelDefinition.texture
				panelTypes.HALL:
					leftSprite.texture = leftHallPanelDefinition.texture
				panelTypes.WALL:
					leftSprite.texture = leftWallPanelDefinition.texture
			match westPanelType:
				panelTypes.DOOR:
					rightSprite.texture = rightDoorPanelDefinition.texture
				panelTypes.HALL:
					rightSprite.texture = rightHallPanelDefinition.texture
				panelTypes.WALL:
					rightSprite.texture = rightWallPanelDefinition.texture
		Vector2i.LEFT:
			match westPanelType:
				panelTypes.DOOR:
					centerSprite.texture = centerDoorPanelDefinition.texture
				panelTypes.HALL:
					centerSprite.texture = centerHallPanelDefinition.texture
				panelTypes.WALL:
					centerSprite.texture = centerWallPanelDefinition.texture
			match southPanelType:
				panelTypes.DOOR:
					leftSprite.texture = leftDoorPanelDefinition.texture
				panelTypes.HALL:
					leftSprite.texture = leftHallPanelDefinition.texture
				panelTypes.WALL:
					leftSprite.texture = leftWallPanelDefinition.texture
			match northPanelType:
				panelTypes.DOOR:
					rightSprite.texture = rightDoorPanelDefinition.texture
				panelTypes.HALL:
					rightSprite.texture = rightHallPanelDefinition.texture
				panelTypes.WALL:
					rightSprite.texture = rightWallPanelDefinition.texture
