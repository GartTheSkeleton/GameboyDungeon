class_name ItemComponent
extends Component

var remain_after_use: bool
var is_activated: bool
var contents: String
var conversation_started: bool = false
var conversation_complete: bool = false
var transaction_complete: bool = false

var mimic_texture = preload("res://src/Assets/Definitions/Entities/Textures/mimic_idle_texture.tres")
var rng = RandomNumberGenerator.new()
var open_chest_texture: AtlasTexture = preload("res://src/Assets/Definitions/Entities/Textures/open_chest.tres")
var unlocked_lever_texture: AtlasTexture = preload("res://src/Assets/Definitions/Entities/Textures/unlocked_lever_texture.tres")

func _init(definition: ItemComponentDefinition, contents = null) -> void:
	remain_after_use = definition.remain_after_use
	is_activated = definition.is_activated
	if contents:
		self.contents = contents
	SignalBus.entity_created.connect(reveal_contents)

func reveal_contents(grid_position: Vector2i, player_grid_position: Vector2i) -> void:
	var parent = get_parent() as Entity
	if is_activated && parent && grid_position == parent.grid_position && player_grid_position == player_grid_position:
		var message = "You found a %s" % contents
		MessageLog.send_message(message)

func activate(parent_entity: Entity) -> void:
	rng.randomize()
	var player = parent_entity.map_data.player
	var map_data = parent_entity.map_data
	if parent_entity.entity_name == "Ammo":
		var result = rng.randi_range(1, 6) + player.fighter_component.luck
		if result >= 6:
			player.fighter_component.stored_ammo += 6
			MessageLog.send_message("You gain 6 bullets!")
		elif result == 2:
			player.fighter_component.stored_ammo += 3
			MessageLog.send_message("You gain 3 bullets!")
		elif result < 2:
			player.fighter_component.stored_ammo += 2
			MessageLog.send_message("You gain 2 bullets!")
		else:
			player.fighter_component.stored_ammo += result
			MessageLog.send_message("You gain %s bullets!" % result)
	if parent_entity.entity_name == "Chest" && !parent_entity.is_mimic:
		parent_entity.texture = open_chest_texture
		MessageLog.send_message("You open the Chest!")
		SignalBus.create_entity.emit(contents, parent_entity.grid_position, contents)
	elif parent_entity.is_mimic:
		parent_entity.texture = mimic_texture
		parent_entity.position.y -= 18
		parent_entity.blocks_movement = true
		parent_entity.entity_name = "That Thing"
		MessageLog.send_message("That's no Chest!")
		SignalBus.start_combat.emit(player, parent_entity)
	elif parent_entity.entity_name == "Lucky Charm":
		player.fighter_component.luck += 1
		player.fighter_component.charms += 1
		SignalBus.stats_changed.emit(player)
		MessageLog.send_message("You feel luckier!")
	elif parent_entity.entity_name == "Knife":
		player.fighter_component.has_knife = true
		SignalBus.reveal_stab_action.emit()
		MessageLog.send_message("Thank the gods; this doesn't need reloading.")
	elif parent_entity.entity_name == "Lever":
		var current_room = map_data.get_tile(parent_entity.grid_position)
		var target_room = map_data.get_tile(current_room.leverTarget)
		if target_room:
			var unlocked = false
			if target_room.northPanelType == target_room.panelTypes.LOCKEDDOOR:
				target_room.northPanelType = target_room.panelTypes.DOOR
				unlocked = true
			if target_room.eastPanelType == target_room.panelTypes.LOCKEDDOOR:
				target_room.eastPanelType = target_room.panelTypes.DOOR
				unlocked = true
			if target_room.southPanelType == target_room.panelTypes.LOCKEDDOOR:
				target_room.southPanelType = target_room.panelTypes.DOOR
				unlocked = true
			if target_room.westPanelType == target_room.panelTypes.LOCKEDDOOR:
				target_room.westPanelType = target_room.panelTypes.DOOR
				unlocked = true
			parent_entity.texture = unlocked_lever_texture
			if unlocked:
				MessageLog.send_message("You hear the echoes of a distant door opening.")
			else:
				MessageLog.send_message("The sound of the lever is echoed only by silence.")
	elif parent_entity.entity_name == "Fairy Merchant":
		conversation_started = true
		if transaction_complete:
			await MessageLog.send_message("La ti dee~! La ti daa~! I've got a Lucky Charm!")
		elif !conversation_complete:
			await MessageLog.send_message("I can invigorate you for a single Lucky Charm!", ["If you aren't interested, keep walkin'!"])
		else:
			if player.fighter_component.charms <= 0:
				await MessageLog.send_message("You ain't got the stuff, SCRAM!")
			elif player.fighter_component.hp == player.fighter_component.max_hp:
				await MessageLog.send_message("You seem pretty vigorous already...", ["I don't take no hand outs! SCRAM!"])
			else:
				await MessageLog.send_message("La ti dee~! La ti daa~! I've got a Lucky Charm!")
				await player.fighter_component.heal(player.fighter_component.max_hp)
				player.fighter_component.charms -= 1
				player.fighter_component.luck -= 1
				transaction_complete = true
	if !parent_entity.entity_name == "Fairy Merchant":
		is_activated = true
	if !remain_after_use:
		parent_entity.free()
	else:
		await get_tree().create_timer(2).timeout
		conversation_complete = true
