extends Control


func update_avatar(avatar_name, texture_path) -> void:
	$VBoxContainer/Label.text = avatar_name
	$VBoxContainer/TextureRect.texture = load(texture_path)
