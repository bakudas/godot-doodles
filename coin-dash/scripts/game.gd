extends Node2D

signal new_level(level: int)
signal update_hud_score(amount: int)
signal on_game_over

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var playtime: int

@export_group("Audios", "audio_")
@export var coin_sound: AudioStream
@export var powerup_sound: AudioStream
@export var end_sound: AudioStream
@export var level_sound: AudioStream

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
	for i in level + time_left:
		var c = coin_scene.instantiate()
		add_child(c)
		c.position = Vector2(
			randi_range(0, DisplayServer.window_get_size().x),
			randi_range(0, DisplayServer.window_get_size().y)
			)
		#print(c.position)
	$Audio/AudioStreamPlayer.stream = level_sound
	$Audio/AudioStreamPlayer.play()


func update_score(amount: int) -> int:
	score += amount
	return score


func game_over() -> void:
	playing = false
	$Audio/AudioStreamPlayer.stream = end_sound
	$Audio/AudioStreamPlayer.play()
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$Background/HUD.show_game_over()
	$Player.hide()


func _on_hud_start_game() -> void:
	new_game()


func _on_player_pickup(amount: int, type: String) -> void:
	match type:
		"coin":
			$Audio/AudioStreamPlayer.stream = coin_sound
			update_hud_score.emit(update_score(amount))
		"powerup":
			time_left += 5
			$Audio/AudioStreamPlayer.stream = powerup_sound
			$Background/HUD.update_timer(time_left)
	$Audio/AudioStreamPlayer.play()

func _on_game_timer_timeout() -> void:
	time_left -= 1
	$Background/HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_player_hurt() -> void:
	game_over()


func _on_powerup_timer_timeout() -> void:
	var pu = powerup_scene.instantiate()
	add_child(pu)
	pu.position = Vector2(
			randi_range(0, DisplayServer.window_get_size().x),
			randi_range(0, DisplayServer.window_get_size().y)
			)
