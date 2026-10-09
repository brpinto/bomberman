extends CanvasLayer

@onready var time_left: int = 200
var score: int
var player

func _ready() -> void:
	player = get_tree().current_scene.get_node("Pausable/Player")
	player.earned_points.connect(_on_points_earned, CONNECT_ONE_SHOT)

func _process(_delta: float) -> void:
	$Seconds.text = str(time_left)
	
func _on_timer_timeout() -> void:
	time_left -= 1

func _on_points_earned(score: int) -> void:
	$Score.text = str(player.stats.score)
