extends Area2D

@export var points = 1

func pickup() -> void:
	queue_free()
