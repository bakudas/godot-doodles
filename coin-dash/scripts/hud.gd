extends Control

signal start_game

func _ready() -> void:
	show_message("Coin Dash!") 


func update_score(value: int) -> void:
	$score.text = str(value)


func update_timer(value: int) -> void:
	$time.text = str(value)


func show_message(text: String) -> void:
	$message.text = text
	$message.show()
	await get_tree().create_timer(2).timeout
	$message.hide()


func show_game_over():
	show_message("Game Over")
	$Button.show()
	#$message.text = "Coin Dash!"
	$message.show()


func _on_button_pressed() -> void:
	$Button.hide()
	show_message("Start Game!")
	start_game.emit()


func _on_game_new_level(level: int) -> void:
	show_message("level {level}".format({'level': level}))


func _on_game_update_hud_score(amount: int) -> void:
	update_score(amount)
