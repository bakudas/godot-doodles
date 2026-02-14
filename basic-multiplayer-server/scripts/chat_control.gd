extends Control

@onready var message_label: Node = $VBoxContainer/ScrollContainer/Label
@onready var container_messages: Node = $VBoxContainer/ScrollContainer
var avatar_name


func _ready() -> void:
	$VBoxContainer/LineEdit.grab_focus()


@rpc("any_peer", "call_local", "reliable", Utils.CHANNEL.CHAT)
func add_message(_avatar_name: String, message: String) -> void:
	var message_text = "%s: %s" % [_avatar_name, message]
	message_label.text = message_label.text + "\n" + message_text
	container_messages.scroll_vertical = message_label.size.y


@rpc
func set_avatar_name(new_avatar_name: String) -> void:
	avatar_name = new_avatar_name


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == "":
		return
	rpc("add_message", avatar_name, new_text)
	$VBoxContainer/LineEdit.clear()
	$VBoxContainer/LineEdit.grab_focus()
