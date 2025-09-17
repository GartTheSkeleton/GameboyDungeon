class_name FighterComponentDefinition
extends Resource

var stored_ammo = 0

@export_category("Stats")
@export var max_hp: int
@export var power: int
@export var luck: int
@export var ammo: int
@export var charms: int

@export_category("Visuals")
@export var death_texture: AtlasTexture
