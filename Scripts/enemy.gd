extends CharacterBody2D

@export var move: Move

var directions: Array = [
	Vector2(0, -8),
	Vector2(0, 8),
	Vector2(-8, 0),
	Vector2(8, 0)
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
	move.map = get_tree().current_scene.get_node("Level")

func _process(delta: float) -> void:
	var free: Array = []
	var cell_pos: Vector2i = floor((self.global_position + directions[curr_dir]) / 16)
	if move.is_solid(cell_pos):
		for i in prout:
			cell_pos = floor((self.global_position + directions[prout[i]]) / 16)
			if not move.is_solid(cell_pos):
				free.append(i)
	
	if free.size() > 0:
		var new_dir = free[randi_range(0, free.size() - 1)]
		curr_dir = prout[new_dir]
	
	if curr_dir == prout.LEFT:
		move.move_h(delta, -1)
	elif curr_dir == prout.RIGHT:
		move.move_h(delta, 1)
	elif curr_dir == prout.UP:
		move.move_v(delta, -1)
	else:
		move.move_v(delta, 1)
