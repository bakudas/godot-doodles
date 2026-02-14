class_name RPCServer extends RPCMultiplayer


const PORT = 4242
@export var database_path = "res://fake_database.json"
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var database: Dictionary = {}
var logger_users: Dictionary = {}
@onready var chat = $ChatControl


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	database = load_database(database_path)
	print(database)
	multiplayer.server_disconnected.connect(_on_player_disconnect)


func _on_player_disconnect() -> void:
	print("saiu")


func load_database(data_path=database_path) -> Dictionary:
	var file = FileAccess.open(data_path, FileAccess.READ)
	var file_content = file.get_as_text()
	var data = JSON.parse_string(file_content)
	return data


@rpc
func add_avatar(avatar_name, texture_path) -> void:
	pass


@rpc
func clear_avatar() -> void:
	pass


@rpc("any_peer", "call_remote")
func retrieve_avatar(user, session_token) -> void:
	var peer_id = multiplayer.get_remote_sender_id()
	
	if not user in logger_users:
		return
	if session_token == logger_users[user]:
		rpc("clear_avatar")
		chat.rpc_id(peer_id, "set_avatar_name", database[user]['name'])
		for logger_user in logger_users:
			var avatar_name = database[logger_user]['name']
			var avatar_texture_path = database[logger_user]['avatar']
			rpc("add_avatar", avatar_name, avatar_texture_path)


@rpc("any_peer", "call_remote")
func authenticate_player(user, password) -> void:
	print('user: %s | pass: %s' % [user, password])
	var peer_id: int = multiplayer.get_remote_sender_id()
	if not user in database:
		rpc_id(peer_id, "authentication_failed", "User doesn't exist")
	elif database[user]['password'] == password:
		var token: int = randi()
		logger_users[user] = token
		rpc_id(peer_id, "authentication_successful", user, token)


@rpc
func authentication_failed(error_message) -> void:
	pass


@rpc
func authentication_successful(user, session_token) -> void:
	pass
