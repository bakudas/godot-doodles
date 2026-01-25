extends Node


func _on_movement_run() -> void:
	$"../AnimatedSprite2D".play("run")
	if $"../Input".velocity.x != 0:
		$"../AnimatedSprite2D".flip_h = $"../Input".velocity.x < 0


func _on_movement_idle() -> void:
	$"../AnimatedSprite2D".play("idle")
