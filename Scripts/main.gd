extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event:
		if event.is_action_pressed("ui_select"):
			toggle_pause()

func toggle_pause():
	var tree = get_tree()
	tree.paused = !tree.paused
	
	if tree.paused:
		$Pausable/Control/Game.text = "Pause"
	else:
		$Pausable/Control/Game.text = "Playing"
