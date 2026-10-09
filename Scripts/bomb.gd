extends Area2D
class_name Bomb

@export var stats: EnemyStats

signal exploded

var destructibles: TileMapLayer
var bombArray: Array = []
var timer: Timer
var damage: int

var TileTransform = [
	TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
	0
]

func _ready() -> void:
	$AnimatedSprite2D.play("exploding")
	destructibles = get_tree().current_scene.get_node("Map/Destructibles")
	damage = stats.damage
	
	#var player = get_tree().current_scene.get_node("Pausable/Player")
	#var local_player_pos = destructibles.to_local(player.global_position)
	#var map_pos = destructibles.local_to_map(local_player_pos)
	#print(map_pos)
	#global_position = player.global_position
	$Timer.start()

func _on_explosion():
	self.visible = false
	var used_cells = destructibles.get_used_cells()
	var pos = destructibles.local_to_map(destructibles.to_local(self.global_position))
	var surrounding = destructibles.get_surrounding_cells(pos)

	var rotation_index = 0
	while rotation_index <= surrounding.size() - 1:
		var data = destructibles.get_cell_tile_data(surrounding[rotation_index])
		if data:
			if data.get_custom_data("destructible"):
				destructibles.set_cell(surrounding[rotation_index], 1, Vector2i(0, 0))
		else:
			destructibles.set_cell(surrounding[rotation_index], 2, Vector2i(0, 0), TileTransform[rotation_index])
		rotation_index += 1
	destructibles.set_cell(pos, 2, Vector2i(0, 2))
	await get_tree().create_timer(0.65).timeout
	for cell in surrounding:
		destructibles.set_cell(cell, -1)
	destructibles.set_cell(pos, -1)
	exploded.emit()
	self.queue_free()
