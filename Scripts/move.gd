extends Resource
class_name Move

@export var speed: int = 50
var animated_sprite: AnimatedSprite2D
var target: CharacterBody2D

func move_h(delta, direction):
	animated_sprite.play("walk_side")
	if direction == -1:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
	target.position.x += direction * delta * speed

func move_v(delta, direction):
	if direction == -1:
		animated_sprite.play("walk_up")
	else:
		animated_sprite.play("walk_down")
	target.position.y += direction * delta * speed
