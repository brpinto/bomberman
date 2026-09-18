extends Resource
class_name Map

var astar_grid: AStarGrid2D
var target: CharacterBody2D
var map: TileMapLayer

func _ready():
	var used_cells = map.get_used_cells()
	if used_cells.is_empty():
		return

	var min_pos = used_cells[0]
	var max_pos = used_cells[0]

	for cell in used_cells:
		min_pos.x = min(min_pos.x, cell.x)
		min_pos.y = min(min_pos.y, cell.y)
		max_pos.x = max(max_pos.x, cell.x)
		max_pos.y = max(max_pos.y, cell.y)

	var grid_size = max_pos - min_pos + Vector2i(1, 1)
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(min_pos, grid_size)
	astar_grid.cell_size = map.tile_set.tile_size
	astar_grid.update()

	for cell in map.get_used_cells():
		var data = map.get_cell_tile_data(cell)
		if data and data.get_custom_data("obstacle"):
			astar_grid.set_point_solid(cell)
			
func is_solid(player_pos: Vector2i) -> bool:
	for cell in map.get_used_cells():
		if cell == player_pos:
			print("cell: ", cell)
			print("player_pos: ", player_pos)
			var data = map.get_cell_tile_data(cell)
			print(data.get_custom_data("obstacle"))
			if data and data.get_custom_data("obstacle"):
				return true
	return false
	
