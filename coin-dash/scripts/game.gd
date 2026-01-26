extends Node2D

signal new_level(level: int)
signal update_hud_score(amount: int)
signal on_game_over

@export var coin_scene: PackedScene
@export var playtime: int
var level: int = 1
var score: int = 0
var time_left: int = 0
var playing: bool = false


func _ready() -> void:
	$Player.hide()


func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		new_level.emit(level)
		time_left += 5
		spawn_coins()


func new_game() -> void:
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.reset_player_position()
	$Player.show()
	$GameTimer.start()
	$Background/HUD.update_score(0)
	$Background/HUD.update_timer(time_left)
	spawn_coins()


func spawn_coins() -> void:
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.position = Vector2(
			randi_range(0, DisplayServer.window_get_size().x),
			randi_range(0, DisplayServer.window_get_size().y)
			)
		print(c.position)


func update_score(amount: int) -> int:
	score += amount
	return score


func game_over() -> void:
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$Background/HUD.show_game_over()
	$Player.hide()


func _on_hud_start_game() -> void:
	new_game()


func _on_player_pickup(amount: int) -> void:
	update_hud_score.emit(update_score(amount))


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$Background/HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_player_hurt() -> void:
	game_over()
