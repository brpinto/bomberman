extends Area2D

@export var damage: Damage

signal exploded

var map: TileMapLayer
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
	map = get_tree().current_scene.get_node("Map")
	var player = get_tree().current_scene.get_node("Pausable/Player")
	var map_pos = map.local_to_map(player.global_position)
	global_position = map.map_to_local(map_pos)
	$Timer.start()

func _on_explosion():
	self.visible = false
	var used_cells = map.destructibles.get_used_cells()
	var pos = map.destructibles.local_to_map(global_position)
	var surrounding = map.destructibles.get_surrounding_cells(pos)

	var rotation_index = 0
	while rotation_index <= surrounding.size() - 1:
		var data = map.destructibles.get_cell_tile_data(surrounding[rotation_index])
		if data:
			if data.get_custom_data("destructible"):
				map.destructibles.set_cell(surrounding[rotation_index], 1, Vector2i(0, 0))
		else:
			map.destructibles.set_cell(surrounding[rotation_index], 2, Vector2i(0, 0), TileTransform[rotation_index])
		rotation_index += 1
	map.destructibles.set_cell(pos, 2, Vector2i(0, 2))
	await get_tree().create_timer(0.65).timeout
	for cell in surrounding:
		map.destructibles.set_cell(cell, -1)
	map.destructibles.set_cell(pos, -1)
	exploded.emit()
	self.queue_free()
