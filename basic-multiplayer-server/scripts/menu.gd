extends Control


func _on_client_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/client.tscn")


func _on_server_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/server.tscn")
