class_name EntityDefinition
extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed Entity"
@export var texture: AtlasTexture

@export_category("Mechanics")
@export var is_blocking_movement: bool = true

@export_category("Components")
@export var fighter_definition: FighterComponentDefinition
@export var item_definition: ItemComponentDefinition
