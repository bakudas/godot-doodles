extends Node

signal run
signal idle

@onready var player = $".."

func _process(delta: float) -> void:
	player.position.x = clamp(player.position.x, 16, DisplayServer.window_get_size().x -16)
	player.position.y = clamp(player.position.y, 16, DisplayServer.window_get_size().y -16)

func _on_input_handle_input(velocity: Vector2, delta: float) -> void:
	player.position += velocity * player.speed * delta
	if velocity != Vector2.ZERO: 
		emit_signal('run')
	else:
		emit_signal('idle')
