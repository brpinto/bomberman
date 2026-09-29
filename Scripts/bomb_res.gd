extends Resource
class_name Bomb

var bomb = preload("res://Scenes/bomb.tscn")
var level: TileMapLayer
var current_scene: Node
var map_pos: Vector2i

func _ready() -> void:
	#global_position = (floor(pos / 16) * 16) + Vector2(8, 8)
	pass
	

	
#var map_pos = move.destructibles.local_to_map(global_position)
	#var tile_data = move.destructibles.get_cell_tile_data(map_pos)
#
	#if tile_data:
		#if tile_data.get_custom_data("destructible"):
			#dead.emit()
