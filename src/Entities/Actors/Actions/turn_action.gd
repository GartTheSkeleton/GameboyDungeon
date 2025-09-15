class_name TurnAction
extends Action

var playerFacing: Vector2i
var direction: String

func _init(inputDirection: String, game: Game) -> void:
	playerFacing = game.playerFacing
	direction = inputDirection
	


func perform(game: Game, entity: Entity) -> void:
	var directionsKeys = game.directions.keys()
	var currentKey = game.playerFacingString
	var currentIndex = directionsKeys.find(currentKey)
	var nextDirection: String
	var current_grid_position = entity.grid_position
	var blocking_enemy = game.get_map_data().get_blocking_entity_at_location(current_grid_position)
	if blocking_enemy:
		return
	if direction == "Left":
		if game.playerFacing == game.directions.NORTH:
#			easy solution, just loop back to other side of the dictionary
			playerFacing = game.directions.WEST
		else:
#			calculate what the previous direction in the dictionary is
			currentIndex -= 1
			nextDirection = directionsKeys[currentIndex]
			playerFacing = game.directions[nextDirection]
			
	if direction == "Right":
		if game.playerFacing == game.directions.WEST:
			#easy solution, just loop back to other side of the dictionary
			playerFacing = game.directions.NORTH
		else:
			#calculate what the next direction in the dictionary is
			currentIndex += 1
			nextDirection = directionsKeys[currentIndex]
			playerFacing = game.directions[nextDirection]
	game.playerFacing = playerFacing
	game.playerFacingString = game.directions.find_key(playerFacing)
	SignalBus.player_turned.emit(playerFacing)
