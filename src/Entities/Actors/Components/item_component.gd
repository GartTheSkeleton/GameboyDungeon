class_name ItemComponent
extends Component

var remain_after_use: bool
var is_activated: bool
var contents: String

var mimic_texture = preload("res://src/Assets/Definitions/Entities/Textures/mimic_idle_texture.tres")

var open_chest_texture: AtlasTexture = preload("res://src/Assets/Definitions/Entities/Textures/open_chest.tres")
func _init(definition: ItemComponentDefinition, contents: String) -> void:
	remain_after_use = definition.remain_after_use
	is_activated = definition.is_activated
	self.contents = contents
	SignalBus.entity_created.connect(reveal_contents)

func reveal_contents(grid_position: Vector2i) -> void:
	var parent = get_parent() as Entity
	if parent && grid_position == parent.grid_position:
		var message = "You found a %s" % contents
		MessageLog.send_message(message)

func activate(parent_entity: Entity) -> void:
	var player = parent_entity.map_data.player
	if parent_entity.entity_name == "Chest" && !parent_entity.is_mimic:
		parent_entity.texture = open_chest_texture
		MessageLog.send_message("You open the Chest!")
		SignalBus.create_entity.emit(contents, parent_entity.grid_position)
	elif parent_entity.is_mimic:
		parent_entity.texture = mimic_texture
		parent_entity.blocks_movement = true
		parent_entity.entity_name = "That thing"
		MessageLog.send_message("That's no Chest!")
		print("beginning combat from mimic")
		SignalBus.start_combat.emit(player, parent_entity)
	elif parent_entity.entity_name == "Lucky Charm":
		player.fighter_component.luck += 1
		player.fighter_component.charms += 1
		SignalBus.stats_changed.emit(player)
		MessageLog.send_message("You feel luckier!")
	is_activated = true
	if !remain_after_use:
		parent_entity.free()
