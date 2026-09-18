extends CharacterBody2D

@export var move: Move
@export var map: Map

const TILE_SIZE = 16
var raycast: RayCast2D

func _ready() -> void:
	move.animated_sprite = $AnimatedSprite2D
	move.target = self
	raycast = $RayCast2D
	map.map = get_tree().current_scene.get_node("TileMapLayer")
	map.target = self
	
func _process(delta: float) -> void:
	var direction: int
	if Input.is_action_pressed("ui_left"):
		direction = -1
		move.move_h(delta, direction)
		raycast.target_position = Vector2(direction * TILE_SIZE, 0)
	if Input.is_action_pressed("ui_right"):
		direction = 1
		move.move_h(delta, direction)
		raycast.target_position = Vector2(direction * TILE_SIZE, 0)
	if Input.is_action_pressed("ui_down"):
		direction = 1
		move.move_v(delta, direction)
		raycast.target_position = Vector2(0, direction * TILE_SIZE)
	if Input.is_action_pressed("ui_up"):
		direction = -1
		move.move_v(delta, direction)
		raycast.target_position = Vector2(0, direction * TILE_SIZE)
	
	if raycast.is_colliding():
		var player_pos = floor(self.global_position / 16)
		var collider = raycast.get_collider()
		print("is_solid: ", map.is_solid(player_pos))
		print(collider)
		
