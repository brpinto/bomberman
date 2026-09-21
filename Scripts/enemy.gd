extends CharacterBody2D

@export var move: Move

func _ready() -> void:
	move.target = self
	move.animated_sprite = $AnimatedSprite2D
	move.map = get_tree().current_scene.get_node("Level")

func _process(delta: float) -> void:
	move.move_h(delta, -1)
