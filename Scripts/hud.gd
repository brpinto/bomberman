extends CanvasLayer

@onready var time_left: int = 200
var score: int

func _ready() -> void:
	var player_score = get_tree().current_scene.get_node("Pausable/Player")
	score = player_score.stats.score
	$Score.text = str(score)

func _process(delta: float) -> void:
	$Seconds.text = str(time_left)

func _on_timer_timeout() -> void:
	time_left -= 1
