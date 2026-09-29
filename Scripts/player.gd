extends CharacterBody2D

@export var move: Move
@export var health: Health
@onready var bomb = preload("res://Scenes/bomb.tscn")

signal exploded
signal dead

var can_put_bomb: bool = true
var raycast: RayCast2D
var destructibles: TileMapLayer

func _ready() -> void:
	move.animated_sprite = $AnimatedSprite2D
	move.target = self
	move.walls = get_tree().current_scene.get_node("Map/Walls")
	move.destructibles = get_tree().current_scene.get_node("Map/Destructibles")

	raycast = $RayCast2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		raycast.target_position = Vector2(-9, 0)
		move.move(delta, Vector2i.LEFT)

	if Input.is_action_pressed("ui_right"):
		raycast.target_position = Vector2(9, 0)
		move.move(delta, Vector2i.RIGHT)

	if Input.is_action_pressed("ui_down"):
		raycast.target_position = Vector2(0, 9)
		move.move(delta, Vector2i.DOWN)

	if Input.is_action_pressed("ui_up"):
		raycast.target_position = Vector2(0, -9)
		move.move(delta, Vector2i.UP)

	if Input.is_key_pressed(KEY_W):
		if can_put_bomb:
			put_bomb(self.global_position)
			can_put_bomb = false

	var map_pos = move.destructibles.local_to_map(global_position)
	var tile_data = move.destructibles.get_cell_tile_data(map_pos)

	if tile_data:
		if tile_data.get_custom_data("destructible"):
			dead.emit()

func _on_player_dead() -> void:
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(3.0).timeout
	self.process_mode = Node.PROCESS_MODE_DISABLED


func put_bomb(pos: Vector2):
	var bomb_instance = bomb.instantiate()
	get_tree().current_scene.add_child(bomb_instance)
	bomb_instance.exploded.connect(_on_explosion, CONNECT_ONE_SHOT)

func _on_explosion():
	can_put_bomb = true
