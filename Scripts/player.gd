extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

func _process(delta: float) -> void:
	var direction: int
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = false
		direction = - 1
		position.x += direction * delta * SPEED
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = true
		direction = 1
		position.x += direction * delta * SPEED
	if Input.is_action_pressed("ui_down"):
		$AnimatedSprite2D.play("walk_down")
		direction = 1
		position.y += direction * delta * SPEED
	if Input.is_action_pressed("ui_up"):
		$AnimatedSprite2D.play("walk_up")
		direction = - 1
		position.y += direction * delta * SPEED
	
