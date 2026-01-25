extends Node

signal handle_input(velocity:Vector2, delta: float)

var velocity: Vector2

func _process(delta: float) -> void:
	velocity = Vector2.ZERO
	velocity = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	handle_input.emit(velocity, delta)
