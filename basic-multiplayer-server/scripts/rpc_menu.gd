extends Control


func _on_client_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rpc_login_screen.tscn")


func _on_server_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rpc_server.tscn")
