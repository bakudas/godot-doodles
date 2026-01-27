extends Node2D

@export var rock_scene: PackedScene = preload("res://scenes/rock.tscn")
var screensize: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = get_viewport_rect().size
	for i in 3:
		spawn_rock(3)


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
