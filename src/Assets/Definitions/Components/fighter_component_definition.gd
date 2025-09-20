class_name FighterComponentDefinition
extends Resource


@export_category("Stats")
@export var max_hp: int
@export var power: int
@export var luck: int
@export var ammo: int
@export var stored_ammo = 0
@export var charms: int

@export_category("Visuals")
@export var death_texture: AtlasTexture
@export var hurt_texture: AtlasTexture
@export var attack_texture: AtlasTexture
@export var idle_texture: AtlasTexture
