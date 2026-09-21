extends CharacterBody2D

@export var move: Move

const TILE_SIZE = 16
var raycast: RayCast2D

func _ready() -> void:
	move.animated_sprite = $AnimatedSprite2D
	move.target = self
	move.map = get_tree().current_scene.get_node("Level")
	
func _process(delta: float) -> void:
	pass
	#move.move(delta, direction)

func _unhandled_key_input(event: InputEvent) -> void:
	var delta = get_process_delta_time()
	if event:
		var direction: int
		if event.is_action("ui_left"):
			direction = -1
			move.move_h(delta, direction)
		if event.is_action("ui_right"):
			direction = 1
			move.move_h(delta, direction)
		if event.is_action("ui_down"):
			direction = 1
			move.move_v(delta, direction)
		if event.is_action("ui_up"):
			direction = -1
			move.move_v(delta, direction)
		move.move(delta, direction)
