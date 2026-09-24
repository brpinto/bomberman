extends Area2D

@export var bomb: Bomb
var walls: TileMapLayer
var destructibles: TileMapLayer
var bombArray: Array = []
var timer: Timer

var TileTransform = [
	TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
	0
]

func _ready() -> void:
	$AnimatedSprite2D.play("exploding")
	bomb.level = get_tree().current_scene.get_node("Map")
	destructibles = bomb.level.destructibles
	var test = get_tree().current_scene.get_node("Pausable/Player")
	test.connect("exploded", _on_timer_timeout)

func _on_timer_timeout():
	self.visible = false
	var used_cells = destructibles.get_used_cells()
	var pos = destructibles.local_to_map(global_position)
	var surrounding = destructibles.get_surrounding_cells(pos)

	var rotation_index = 0
	while rotation_index <= surrounding.size() - 1:
		destructibles.set_cell(surrounding[rotation_index], 2, Vector2i(0, 0), TileTransform[rotation_index])
		rotation_index += 1
	destructibles.set_cell(pos, 2, Vector2i(0, 2))
	await get_tree().create_timer(0.65).timeout
	for cell in surrounding:
		destructibles.set_cell(cell, -1)
	destructibles.set_cell(pos, -1)
	self.queue_free()
