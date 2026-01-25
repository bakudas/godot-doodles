extends Node2D


@export var coin_scene: PackedScene
@export var playtime: int = 30
var level: int = 1
var score: int = 0
var time_left: int = 0
var playing: bool = true

func _ready() -> void:
	#$Player.hide()
	pass

func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
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
