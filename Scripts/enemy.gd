extends CharacterBody2D
class_name Enemy

@export var move: Move
@export var stats: EnemyStats

signal dead()

var raycast: RayCast2D
var curr_dir: Vector2 = Vector2.LEFT
var bomb
var can_move: bool
var health: int
var damage: int
var point: int
var speed: int = 20

func _ready() -> void:
	move.target = self
	can_move = true
	move.animated_sprite = $AnimatedSprite2D
	move.walls = get_tree().current_scene.get_node("Map/Walls")
	move.destructibles = get_tree().current_scene.get_node("Map/Destructibles")
	
	health = stats.health
	damage = stats.damage
	point = stats.point

	raycast = $RayCast2D

func _physics_process(_delta: float) -> void:
	var free: Array = []
	var enemy_pos = move.walls.map_to_local(move.walls.local_to_map(move.walls.to_local(self.global_position)))
	enemy_pos = move.walls.local_to_map(enemy_pos)
	
	raycast.target_position = curr_dir * 9
#
	if raycast.is_colliding():
		var surroundings = move.walls.get_surrounding_cells(enemy_pos)
		for cell in surroundings:
			if move.is_walkable(cell):
				free.append(cell)

	if free.size() > 0:
		var new_dir: Vector2 = free[randi_range(0, free.size() - 1)]
		curr_dir = new_dir - Vector2(enemy_pos.x, enemy_pos.y)
	
	if curr_dir == Vector2.RIGHT:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	if can_move:
		velocity = curr_dir * speed
		move_and_slide()

	var map_pos = move.destructibles.local_to_map(move.destructibles.to_local(self.global_position))
	var tile_data = move.destructibles.get_cell_tile_data(map_pos)
	if tile_data:
		if tile_data.get_custom_data("explosion"):
			take_damage(100)

func _on_death() -> void:
	can_move = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	
	await get_tree().create_timer(5.0).timeout
	self.process_mode = Node.PROCESS_MODE_DISABLED
 
func take_damage(amount: int) -> void:
	self.health -= amount
	
	if self.health <= 0:
		dead.emit()
