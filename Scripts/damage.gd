extends Resource
class_name Damage

@export var amount: int

func deal_damage(target: CharacterBody2D):
	target.health -= amount
