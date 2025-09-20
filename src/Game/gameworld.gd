class_name Game
extends Node2D

signal player_created(player)

var directions = {
	"NORTH": Vector2i.UP, 
	"EAST": Vector2i.RIGHT, 
	"SOUTH": Vector2i.DOWN, 
	"WEST": Vector2i.LEFT
}

var playerFacing: Vector2i = directions["NORTH"]
var playerFacingString: String = directions.find_key(playerFacing)

@onready var camera: Camera2D = $Camera2D
@onready var input_handler: InputHandler = $InputHandler
@onready var entities: Node2D = $Entities
@onready var map: Map = $Map
@onready var combat_manager: CombatManager = %CombatManager
@onready var combat_menu: CombatMenu = %CombatMenu

@onready var player: Entity

var gun_bob = false
var bob_timer = 0
var bob_time = 18
var time : float
@onready var gun = $Camera2D/Gun

var currentRoom: Tile
var rng = RandomNumberGenerator.new()
const entity_types = {
	"cyclops": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_cyclops.tres"),
	"skeleton": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_skeleton.tres"),
	"player": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_player.tres"),
	"key": preload("res://src/Assets/Definitions/Entities/Items/entity_definition_key.tres"),
	"charm": preload("res://src/Assets/Definitions/Entities/Items/entity_definition_charm.tres"),
	"chest": preload("res://src/Assets/Definitions/Entities/Items/entity_definition_chest.tres"),
	"mimic": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_mimic.tres"),
	"abomination": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_abomination.tres"),
	"slug": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_slime.tres")
}

var random_remarks = [
	"\"Hm, stepped in a puddle.\"",
	"\"Have I been in this room before?\"",
	"\"I'm so tired.\"",
	"\"I hope that smell isn't me...\"",
	"\"It's so dark down here...\"",
	"\"Smells like mold...\"",
	"\"Did I hear something?\"",
	"\"Deep breaths... Deep breaths.\"",
	"\"Getting hungry.\"",
	"\"I feel like I'm being watched...\"",
	"\"What even is this place?\"",
	"\"Did I hear something crying?\"",
	"\"Thought I heard something groan.\"",
	"\"Every hall looks the same...\"",
	"\"Why's it so damp down here?\"",
	"\"Just... Keep... Going...\"",
	"\"Count my bullets... Can't run out...\"",
	"\"It's so cold down here.\"",
	"\"I'm really testing my luck...\"",
	"\"I hear something breathing...\""
]

func _ready() -> void:
	create_player()
	SignalBus.start_combat.connect(combat_manager.begin_combat)
	SignalBus.create_entity.connect(createEntity)
	SignalBus.player_died.connect(handle_player_death)
	SignalBus.gameworld_ready.emit()

func createEntity(name: String, grid_pos: Vector2i, chest_contents = null):
	var new_entity: Entity
	var map_data = get_map_data()
	match name:
		"Lucky Charm":
			new_entity = Entity.new(grid_pos, entity_types.charm, map_data)
			new_entity.position.y -= 16
		"Abomination":
			new_entity = Entity.new(grid_pos, entity_types.abomination, map_data)
		"Mimic": 
			new_entity = Entity.new(grid_pos, entity_types.mimic, map_data)
			new_entity.item_component.contents = "Lucky Charm"
		"Chest": 
			new_entity = Entity.new(grid_pos, entity_types.chest, map_data)
			if chest_contents:
				new_entity.item_component.contents = chest_contents
		"Cyclops":
			new_entity = Entity.new(grid_pos, entity_types.cyclops, map_data)
		"Skeleton":
			new_entity = Entity.new(grid_pos, entity_types.skeleton, map_data)
		"Slug":
			new_entity = Entity.new(grid_pos, entity_types.slug, map_data)
		
	if !new_entity:
		return
	entities.add_child(new_entity)
	map_data.entities.append(new_entity)
	for entity in map_data.entities:
		entity.map_data = map_data
	SignalBus.entity_created.emit(grid_pos)

func _process(delta: float) -> void:
	time += delta


func _physics_process(_delta: float) -> void:
	if !combat_manager.has_begun:
		var action: Action = input_handler.get_action()
		if action:
			await action.perform(self, player)
			var entity_in_room = get_map_data().get_entity_at_location(player.grid_position)
			gun_bob = true
			bob_timer = 0
			
			if entity_in_room:
				var message: String
				if entity_in_room.fighter_component && !entity_in_room.item_component:
					if entity_in_room.fighter_component.hp > 0:
						message = "AHH! A %s!" % entity_in_room.entity_name
						combat_manager.begin_combat(player, entity_in_room)
				else:
					if !entity_in_room.item_component.is_activated:
						message = "You found a %s!" % entity_in_room.entity_name
				if message:
					MessageLog.send_message(message)
			elif action is MovementAction:
				rng.randomize()
				var chance: int = rng.randi_range(0, 10)
				if chance > 8:
					var index: int = rng.randi_range(0, random_remarks.size() - 1)
					var message = random_remarks[index]
					MessageLog.send_message(message)
		if gun_bob:
			gun.position.y += get_sine(time)
			bob_timer += 1
			if bob_timer >= bob_time:
				gun_bob = false
				bob_timer = 0
		else:
			gun.position.y = 0

func get_map_data() -> MapData:
	return map.map_data

func create_player() -> void:
	var map_data = get_map_data()
	var player_start_pos: Vector2i = Vector2i.ZERO
	player = Entity.new(player_start_pos, entity_types.player, map_data)
	player.position = player_start_pos
	map_data.player = player
	remove_child(camera)
	player.add_child(camera)
	entities.add_child(player)
	player_created.emit(player)
	SignalBus.player_turned.emit(playerFacing)

func get_sine(time):
	return sin(time * 40) * .6

func handle_player_death() -> void:
	input_handler.external_transition_to(InputHandler.InputHandlers.GAME_OVER)
