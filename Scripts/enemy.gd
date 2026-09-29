extends CharacterBody2D

@export var move: Move

signal dead

var raycast: RayCast2D

var directions: Array = [
	Vector2i(0, -1),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(1, 0)
]

enum LIT_DIR {
	UP = 0,
	DOWN = 1,
	LEFT = 2,
	RIGHT = 3
}

var curr_dir = LIT_DIR.LEFT

func _ready() -> void:
	move.target = self
	move.animated_sprite = $AnimatedSprite2D
	move.walls = get_tree().current_scene.get_node("Map/Walls")
	move.destructibles = get_tree().current_scene.get_node("Map/Destructibles")
	raycast = $RayCast2D
	
	
func _process(delta: float) -> void:
	var free: Array = []
	var enemy_pos = move.walls.local_to_map(self.global_position)
	var cell_pos: Vector2i = enemy_pos + directions[curr_dir]
	
	raycast.target_position = directions[curr_dir] * 9
#
	if raycast.is_colliding():
		var surroundings = move.walls.get_surrounding_cells(enemy_pos)
		for cell in surroundings:
			if move.is_walkable(cell):
				free.append(cell)

	if free.size() > 0:
		var new_dir = free[randi_range(0, free.size() - 1)]
		var test = new_dir - enemy_pos
		print(test)
		#raycast.target_position = directions[curr_dir]
		
	#if curr_dir == LIT_DIR.LEFT:
	move.move_h(delta, "LEFT")
	#elif curr_dir == LIT_DIR.RIGHT:
		#move.move_h(delta, "RIGHT")
	#elif curr_dir == LIT_DIR.UP:
		#move.move_v(delta, "UP")
	#else:
		#move.move_v(delta, "DOWN")
#
	#var map_pos = move.destructibles.local_to_map(self.global_position)
	#var tile_data = move.destructibles.get_cell_tile_data(map_pos)
	#if tile_data:
		#if tile_data.get_custom_data("destructible"):
			#dead.emit()


func _on_death() -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(5.0).timeout
	self.process_mode = Node.PROCESS_MODE_DISABLED
