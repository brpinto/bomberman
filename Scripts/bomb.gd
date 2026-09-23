extends Area2D

@export var bomb: Bomb
var walls: TileMapLayer

func _ready() -> void:
	$AnimatedSprite2D.play("exploding")
	bomb.level = get_tree().current_scene.get_node("Map")
	walls = bomb.level.walls

	var used_cells = walls.get_used_cells()
	var pos = walls.local_to_map(global_position)
	var surrounding = walls.get_surrounding_cells(pos)

	for cell in surrounding:
		for used in used_cells:
			if cell == used:
				print(cell)
	
func _process(delta: float) -> void:
	pass
