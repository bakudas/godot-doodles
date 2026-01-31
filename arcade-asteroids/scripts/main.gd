extends Node2D

@export var rock_scene: PackedScene = preload("res://scenes/rock.tscn")
var screensize: Vector2 = Vector2.ZERO
var level: int = 0
var score: int = 0
var is_playing = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = get_viewport_rect().size


func _process(delta: float) -> void:
	if not is_playing:
		return
	if get_tree().get_nodes_in_group("rocks").size() == 0:
		new_level()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not is_playing:
			return
		get_tree().paused = not get_tree().paused
		var message = $HUD/VBoxContainer/Message
		if get_tree().paused:
			message.text = "Paused"
			message.show()
		else:
			message.text = ""
			message.hide()


func new_game() -> void:
	# remove any old rocks from previous run
	get_tree().call_group('rocks', "queue_free")
	level = 0
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Player.reset()
	$Player.show()
	await $HUD/Timer.timeout
	is_playing = true


func new_level() -> void:
	level += 1
	$HUD.show_message("Wave %s" % level)
	for i in level:
		spawn_rock(i + 3)


func game_over() -> void:
	is_playing = false
	$Player.hide()
	$HUD.game_over()


func spawn_rock(size, pos=null, vel=null) -> void:
	if pos == null:
		$RockPath/RockSpawn.progress = randi()
		pos = $RockPath/RockSpawn.position
	if vel == null:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50, 125)
	var r = rock_scene.instantiate()
	r.screensize = screensize
	r.start(pos, vel, size)
	call_deferred("add_child", r)
	r.exploded.connect(self._on_rock_exploded) # connect signal rock explode


func _on_rock_exploded(size: int, radius: float, pos: Vector2, vel: Vector2) -> void:
	if size <= 1: 
		return
	for offset in [-1, 1]:
		var dir: Vector2 = $Player.position.direction_to(pos).orthogonal() * offset
		var new_pos: Vector2 = pos + dir * radius
		var new_vel: Vector2 = dir * vel.length()
		spawn_rock(size - 1, new_pos, new_vel)
