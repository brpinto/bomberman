extends CharacterBody2D

@export var move: Move

const TILE_SIZE = 16
var raycast: RayCast2D

func _ready() -> void:
	move.animated_sprite = $AnimatedSprite2D
	move.target = self
	move.map = get_tree().current_scene.get_node("Level")
	
func _process(delta: float) -> void:
	var direction: int
	if Input.is_action_pressed("ui_left"):
		direction = -1
		move.move_h(delta, direction)
	if Input.is_action_pressed("ui_right"):
		direction = 1
		move.move_h(delta, direction)
	if Input.is_action_pressed("ui_down"):
		direction = 1
		move.move_v(delta, direction)
	if Input.is_action_pressed("ui_up"):
		direction = -1
		move.move_v(delta, direction)
