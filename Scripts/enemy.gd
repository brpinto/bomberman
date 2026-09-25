extends CharacterBody2D

@export var move: Move

signal dead

var raycast: RayCast2D
var destructibles: TileMapLayer
var can_move = true

var directions: Array = [
	Vector2(0, -9),
	Vector2(0, 9),
	Vector2(-9, 0),
	Vector2(9, 0)
]

enum prout {
	UP = 0,
	DOWN = 1,
	LEFT = 2,
	RIGHT = 3
}

var curr_dir = prout.LEFT

func _ready() -> void:
	move.target = self
	move.animated_sprite = $AnimatedSprite2D
	move.walls = get_tree().current_scene.get_node("Map/Walls")
	move.destructibles = get_tree().current_scene.get_node("Map/Destructibles")
	raycast = $RayCast2D
	
	
func _process(delta: float) -> void:
	pass
	#if not can_move:
		#return
	#var free: Array = []
	#var cell_pos: Vector2i = floor((self.global_position + directions[curr_dir]) / 16)
	#raycast.target_position = directions[curr_dir]
	#if move.is_solid(cell_pos) or raycast.is_colliding():
		#for i in prout:
			#cell_pos = floor((self.global_position + directions[prout[i]]) / 16)
			#raycast.target_position = directions[prout[i]]
			#if not move.is_solid(cell_pos) or not raycast.is_colliding():
				#free.append(i)
	#
	#if free.size() > 0:
		#var new_dir = free[randi_range(0, free.size() - 1)]
		#curr_dir = prout[new_dir]
		#raycast.target_position = directions[curr_dir]
		#
	#if curr_dir == prout.LEFT:
		#move.move_h(delta, "LEFT")
	#elif curr_dir == prout.RIGHT:
		#move.move_h(delta, "RIGHT")
	#elif curr_dir == prout.UP:
		#move.move_v(delta, "UP")
	#else:
		#move.move_v(delta, "DOWN")
#
	#var map_pos = destructibles.local_to_map(global_position)
	#var tile_data = destructibles.get_cell_tile_data(map_pos)
	#if tile_data:
		#if tile_data.get_custom_data("destructible"):
			#dead.emit()


func _on_death() -> void:
	can_move = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(5.0).timeout
	self.process_mode = Node.PROCESS_MODE_DISABLED
