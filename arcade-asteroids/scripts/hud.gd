extends CanvasLayer

signal start_game

@onready var lives_counter: Array[Node] = $MarginContainer/HBoxContainer/LivesCountes.get_children()
@onready var score_labe : Node = $MarginContainer/HBoxContainer/Score
@onready var message: Node = $VBoxContainer/Message
@onready var start_Button: Node = $VBoxContainer/StartButton


func show_message(text: String) -> void:
	message.text = text
	message.show()
	$Timer.start()


func update_score(value: int) -> void:
	score_labe.text = str(value)


func update_lives(value: int) -> void:
	for item in 3:
		lives_counter[item].visible = value > item


func game_over() -> void:
	show_message("Game Over")
	await $Timer.timeout
	start_Button.show()


func _on_start_button_pressed() -> void:
	start_Button.hide()
	start_game.emit()


func _on_timer_timeout() -> void:
	message.hide()
	message.text = ""
