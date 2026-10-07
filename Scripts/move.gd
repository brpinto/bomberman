extends Resource
class_name Move

@export var speed: int
var animated_sprite: AnimatedSprite2D
var target: CharacterBody2D
var astar_grid: AStarGrid2D
var walls: TileMapLayer
var destructibles: TileMapLayer
var solid_walls: Array[Vector2i]
var destructible_walls: Array[Vector2i]
var dir_vect

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

func move(delta, direction: Vector2):
	if direction == Vector2.LEFT:
		animated_sprite.flip_h = false
		animated_sprite.play("walk_side")
	elif direction == Vector2.RIGHT:
		animated_sprite.flip_h = true
		animated_sprite.play("walk_side")
	elif direction == Vector2.UP:
		animated_sprite.flip_h = true
		animated_sprite.play("walk_up")
	elif direction == Vector2.DOWN:
		animated_sprite.flip_h = false
		animated_sprite.play("walk_down")

	target.velocity = direction * speed
	target.move_and_slide()
	#var target_pos = walls.local_to_map(target.global_position)
	#var cell_pos = target_pos + direction
	#
	#if not target.raycast.is_colliding():
		#target.global_position += direction as Vector2 * delta * speed
