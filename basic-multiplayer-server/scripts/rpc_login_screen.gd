class_name RPCLogin extends RPCMultiplayer

const PORT: int = 4242
const HOST: String = "127.0.0.1"
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
@onready var user_line_edit: Node = $VBoxContainer/UserLineEdit
@onready var password_line_edit: Node = $VBoxContainer/PasswordLineEdit
@onready var error_label: Node = $VBoxContainer/ErroMessage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	peer.create_client(HOST, PORT)
	multiplayer.multiplayer_peer = peer


func send_credentials() -> void:
	var user = user_line_edit.text
	var password = password_line_edit.text
	rpc_id(get_multiplayer_authority(), "authenticate_player", user, password)


@rpc
func add_avatar(avatar_name, texture_path) -> void:
	pass


@rpc
func clear_avatar() -> void:
	pass


@rpc("any_peer", "call_remote")
func retrieve_avatar(user, session_token) -> void:
	pass


@rpc("any_peer", "call_remote")
func authenticate_player(user, password) -> void:
	pass


@rpc
func authentication_failed(error_message) -> void:
	error_label.text = error_message


@rpc
func authentication_successful(user, session_token) -> void:
	print('user: %s | session_token: %s' % [user, session_token])
	AuthenticationCredentials.username = user_line_edit.text
	AuthenticationCredentials.access_token = session_token
	get_tree().change_scene_to_file("res://scenes/rpc_client.tscn")


func _on_login_button_pressed() -> void:
	send_credentials()
