extends CharacterBody2D

@export var move: Move
@export var bomb: Bomb

signal exploded
signal dead

var can_put_bomb: bool = true
const TILE_SIZE = 16
var raycast: RayCast2D
var destructibles: TileMapLayer

func _ready() -> void:
	move.animated_sprite = $AnimatedSprite2D
	move.target = self
	move.map = get_tree().current_scene.get_node("Level")
	destructibles = get_tree().current_scene.get_node("Map/Destructibles")
	
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
			
	var map_pos = destructibles.local_to_map(global_position)
	var tile_data = destructibles.get_cell_tile_data(map_pos)
	if tile_data:
		if tile_data.get_custom_data("explosion"):
			dead.emit()
			

func _on_bomb_timer_timeout() -> void:
	can_put_bomb = true
	exploded.emit()

func put_bomb(pos: Vector2):
	var bomb_instance = bomb.bomb.instantiate()
	bomb_instance.global_position = (floor(pos / 16) * 16) + Vector2(8, 8)
	get_tree().current_scene.add_child(bomb_instance)

func _on_player_dead() -> void:
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(3.0).timeout
	self.process_mode = Node.PROCESS_MODE_DISABLED
