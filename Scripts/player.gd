extends CharacterBody2D

@export var move: Move
@export var stats: PlayerStats
@onready var bomb_instance = preload("res://Scenes/bomb.tscn")

signal dead
signal earned_points(score: int)

var can_put_bomb: bool = true
var raycast: RayCast2D
var destructibles: TileMapLayer
var bomb: Bomb
var health: int
var score: int
var can_move: bool = true
var speed: int = 50

func _ready() -> void:
	move.animated_sprite = $AnimatedSprite2D
	move.target = self
	move.walls = get_tree().current_scene.get_node("Map/Walls")
	move.destructibles = get_tree().current_scene.get_node("Map/Destructibles")
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	print(enemies.size())
	for enemy in enemies:
		enemy.dead.connect(_on_enemy_death, CONNECT_ONE_SHOT)
	
	health = stats.health
	score = stats.score
	raycast = $RayCast2D

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if not raycast.is_colliding() and can_move:
		if direction == Vector2.LEFT:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_side")
		elif direction == Vector2.RIGHT:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk_side")
		elif direction == Vector2.UP:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk_up")
		elif direction == Vector2.DOWN:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_down")
	
		velocity = direction * speed
		move_and_slide()

	$RayCast2D.target_position = direction * 9
	if Input.is_key_pressed(KEY_W):
		if can_put_bomb:
			put_bomb()
			can_put_bomb = false

	var map_pos = move.destructibles.local_to_map(move.destructibles.to_local(global_position))
	var tile_data = move.destructibles.get_cell_tile_data(map_pos)
	
	if tile_data:
		if tile_data.get_custom_data("explosion"):
			take_damage(100)
#
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is Enemy:
			take_damage(collider.stats.damage)

func put_bomb():
	var new_bomb = bomb_instance.instantiate()
	new_bomb.global_position = move.walls.map_to_local(move.walls.local_to_map(self.global_position))
	get_tree().current_scene.add_child(new_bomb)
	new_bomb.exploded.connect(_on_explosion, CONNECT_ONE_SHOT)

func _on_explosion():
	can_put_bomb = true

func _on_death():
	can_move = false
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(2.5).timeout
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		dead.emit()

func _on_enemy_death(point: int) -> void:
	stats.score += point
	earned_points.emit(score)
