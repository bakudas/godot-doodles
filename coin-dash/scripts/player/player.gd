extends Area2D

signal pickup
signal hurt

@export var speed: int = 350

func _init() -> void:
	reset_player_position()


func reset_player_position() -> void:
	position.x = DisplayServer.window_get_size().x / 2
	position.y = DisplayServer.window_get_size().y / 2


func take_damage() -> void:
	hurt.emit()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('coins'):
		area.pickup()
		pickup.emit()
	if area.is_in_group('obstacles'):
		take_damage()
