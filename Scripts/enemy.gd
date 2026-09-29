extends CharacterBody2D

@export var move: Move

signal dead

var raycast: RayCast2D
var curr_dir = Vector2i.LEFT

func _ready() -> void:
	move.target = self
	move.animated_sprite = $AnimatedSprite2D
	move.walls = get_tree().current_scene.get_node("Map/Walls")
	move.destructibles = get_tree().current_scene.get_node("Map/Destructibles")
	raycast = $RayCast2D

func _process(delta: float) -> void:
	var free: Array = []
	var enemy_pos = move.walls.local_to_map(self.global_position)
	var cell_pos: Vector2i = enemy_pos + curr_dir

	raycast.target_position = curr_dir * 9

	if raycast.is_colliding():
		var surroundings = move.walls.get_surrounding_cells(enemy_pos)
		for cell in surroundings:
			if move.is_walkable(cell):
				free.append(cell)

	if free.size() > 0:
		var new_dir = free[randi_range(0, free.size() - 1)]
		curr_dir = new_dir - enemy_pos

	if curr_dir == Vector2i.RIGHT:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	move.move(delta, curr_dir)

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
