extends VBoxContainer

@onready var luck_label: Label = %Luck
@onready var ammo_label: Label = %Ammo
@onready var charms_label: Label = %Charms
@onready var luck_sprite: Sprite2D = %LuckUI
@onready var ammo_sprite: Sprite2D = %AmmoUI
@onready var charms_sprite: Sprite2D = %CharmUI
var luck: String
var ammo: String
var charms: String
var luck_ui_texture = preload("res://src/Assets/Definitions/Entities/Textures/luck_texture.tres")
var ammo_ui_texture = preload("res://src/Assets/Definitions/Entities/Textures/ammo.tres")
var charms_ui_texture = preload("res://src/Assets/Definitions/Entities/Textures/charms.tres")

func update_stat_labels(player: Entity) -> void:
	luck = str(player.luck)
	ammo = str(player.ammo)
	charms = str(player.charms)

func _ready() -> void:
	SignalBus.stats_changed.connect(update_stat_labels)
	luck_sprite.texture = luck_ui_texture
	ammo_sprite.texture = ammo_ui_texture
	charms_sprite.texture = charms_ui_texture

func _process(delta: float) -> void:
	luck_label.text = luck
	ammo_label.text = ammo
	charms_label.text = charms
