extends CharacterBody2D
@export var move: Move

func _ready() -> void:
	move.animated_sprite = $AnimatedSprite2D
	move.target = self

func _process(delta: float) -> void:
	var direction: int
	if Input.is_action_pressed("ui_left"):
		move.move_h(delta, -1)
	if Input.is_action_pressed("ui_right"):
		move.move_h(delta, 1)
	if Input.is_action_pressed("ui_down"):
		move.move_v(delta, 1)
	if Input.is_action_pressed("ui_up"):
		move.move_v(delta, -1)
