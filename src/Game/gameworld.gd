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
@onready var event_handler: EventHandler = $EventHandler
@onready var entities: Node2D = $Entities
@onready var map: Map = $Map

@onready var player: Entity

var currentRoom: Tile
var rng = RandomNumberGenerator.new()
const entity_types = {
	"cyclops": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_cyclops.tres"),
	"player": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_player.tres"),
	"key": preload("res://src/Assets/Definitions/Entities/Items/entity_definition_key.tres"),
	"charm": preload("res://src/Assets/Definitions/Entities/Items/entity_definition_charm.tres"),
	"chest": preload("res://src/Assets/Definitions/Entities/Items/entity_definition_chest.tres"),
	"mimic": preload("res://src/Assets/Definitions/Entities/Actors/entity_definition_mimic.tres")
}

var random_remarks = [
	"\"Hm, stepped in a puddle.\"",
	"\"Have I been in this room before?\"",
	"\"I'm so tired.\"",
	"\"I hope that smell isn't me...\"",
	"\"It's so dark down here...\"",
	"\"Smells like mold...\"",
	"\"Did I hear something?\"",
	"\"Deep breaths... Deep breaths.\""
]

func _ready() -> void:
	populate_map()
	SignalBus.create_entity.connect(createEntity)

func createEntity(name: String, grid_pos: Vector2i):
	var new_entity: Entity
	var map_data = get_map_data()
	match name:
		"Lucky Charm":
			new_entity = Entity.new(grid_pos, entity_types.charm, map_data)
			new_entity.position.y -= 16
	if !new_entity:
		return
	entities.add_child(new_entity)
	map_data.entities.append(new_entity)
	SignalBus.entity_created.emit(grid_pos)

func _physics_process(_delta: float) -> void:
	var action: Action = event_handler.get_action()
	if action:
		await action.perform(self, player)
		var entity_in_room = get_map_data().get_entity_at_location(player.grid_position)
		if entity_in_room:
			var message: String
			if entity_in_room.fighter_component && !entity_in_room.item_component:
				if entity_in_room.fighter_component.hp > 0:
					message = "AHH! A %s!" % entity_in_room.entity_name
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

func get_map_data() -> MapData:
	return map.map_data

func populate_map() -> void:
	rng.randomize()
	var map_data = get_map_data()
	var player_start_pos: Vector2i = Vector2i.ZERO
	player = Entity.new(player_start_pos, entity_types.player, map_data)
	player.position = player_start_pos
	map_data.player = player
	remove_child(camera)
	player.add_child(camera)
	entities.add_child(player)
	player_created.emit(player)
	for room in map_data.tiles:
		var random_chance = rng.randf_range(0, 10.0)
		if random_chance > 7.5 && room.gridPosition != Vector2i.ZERO:
			var npc := Entity.new(room.gridPosition, entity_types.cyclops, map_data)
			npc.position.y -= 6
			entities.add_child(npc)
			map_data.entities.append(npc)
		elif random_chance < 3 && room.gridPosition != Vector2i.ZERO:
			var item := Entity.new(room.gridPosition, entity_types.mimic, map_data)
			item.position.y += 8
			entities.add_child(item)
			map_data.entities.append(item)
	SignalBus.player_turned.emit(playerFacing)
