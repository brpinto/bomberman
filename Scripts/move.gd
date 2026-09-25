extends Resource
class_name Move

@export var speed: int = 50
var animated_sprite: AnimatedSprite2D
var target: CharacterBody2D
var astar_grid: AStarGrid2D
var walls: TileMapLayer
var destructibles: TileMapLayer
var solid_walls: Array[Vector2i]
var destructible_walls: Array[Vector2i]
var dir_vect: Vector2

enum LITTERAL_DIR {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

var directions = [
	Vector2i(0, -1),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(1, 0)
]

func _ready():
	solid_walls = walls.get_used_cells()
	destructible_walls = destructibles.get_used_cells()

	if walls.is_empty() or destructibles.is_empty():
		return

func is_walkable(cell_to_check: Vector2i) -> bool:
	var wall_data = walls.get_cell_tile_data(cell_to_check)
	var destructible_data = destructibles.get_cell_tile_data(cell_to_check)
	var is_wall: bool
	var is_destructible: bool

	if wall_data and wall_data.get_custom_data("obstacle"):
		is_wall = true
	if destructible_data and destructible_data.get_custom_data("destructible"):
		is_destructible = true
	
	if is_wall:
		return false
	elif is_destructible:
		return false
	
	return true

func move_h(delta, direction):
	animated_sprite.play("walk_side")
	
	if direction == "LEFT":
		dir_vect = Vector2.LEFT
		animated_sprite.flip_h = false
	else:
		dir_vect = Vector2.RIGHT
		animated_sprite.flip_h = true

	var player_pos = walls.local_to_map(target.global_position)
	var cell_pos: Vector2i = player_pos + directions[LITTERAL_DIR[direction]]
	print("to_go: ", cell_pos)
	print("player_pos: ", player_pos)
	print(target.raycast.is_colliding())
	if is_walkable(cell_pos) and not target.raycast.is_colliding():
		target.global_position += dir_vect 

func move_v(delta, direction):
	if direction == "UP":
		dir_vect = Vector2.UP
		animated_sprite.play("walk_up")
	else:
		dir_vect = Vector2.DOWN
		animated_sprite.play("walk_down")
	
	var player_pos = walls.local_to_map(target.global_position)
	var cell_pos: Vector2i = player_pos + directions[LITTERAL_DIR[direction]]
	if is_walkable(cell_pos) and not target.raycast.is_colliding():
		target.global_position += dir_vect
