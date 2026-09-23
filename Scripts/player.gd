extends CharacterBody2D

@export var move: Move
@export var bomb: Bomb

var can_put_bomb: bool = true
const TILE_SIZE = 16
var raycast: RayCast2D

func _ready() -> void:
	move.animated_sprite = $AnimatedSprite2D
	move.target = self
	move.map = get_tree().current_scene.get_node("Level")
	raycast = $RayCast2D
	
func _process(delta: float) -> void:
	var direction: int
	if Input.is_action_pressed("ui_left"):
		direction = -1
		raycast.target_position = Vector2(-9, 0)
		move.move_h(delta, direction)
	if Input.is_action_pressed("ui_right"):
		direction = 1
		raycast.target_position = Vector2(9, 0)
		move.move_h(delta, direction)
	if Input.is_action_pressed("ui_down"):
		direction = 1
		raycast.target_position = Vector2(0, 9)
		move.move_v(delta, direction)
	if Input.is_action_pressed("ui_up"):
		direction = -1
		raycast.target_position = Vector2(0, -9)
		move.move_v(delta, direction)
	if Input.is_key_pressed(KEY_W):
		if can_put_bomb:
			put_bomb(global_position)
			can_put_bomb = false
			$BombTimer.start()


func _on_bomb_timer_timeout() -> void:
	can_put_bomb = true
	
func put_bomb(pos: Vector2):
	var bomb_instance = bomb.bomb.instantiate()
	bomb_instance.global_position = (floor(pos / 16) * 16) + Vector2(8, 8)
	get_tree().current_scene.add_child(bomb_instance)
	pass
