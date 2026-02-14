class_name RPCClient extends RPCMultiplayer

const PORT = 4242
const HOST = "127.0.0.1"
@onready var avatar_cart_container: Node = $AvatarCardsScrollContainer/AvatarCardsHBoxContainer
@onready var avatar_card_scene: PackedScene = preload("res://scenes/avatar_card.tscn")
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
@onready var chat = $ChatControl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	peer.create_client(HOST, PORT)
	var authority_id = get_multiplayer_authority()
	rpc_id(
		authority_id, 
		"retrieve_avatar", 
		AuthenticationCredentials.username, 
		AuthenticationCredentials.access_token
	)


@rpc
func add_avatar(avatar_name, texture_path) -> void:
	var avatar_card = avatar_card_scene.instantiate()
	avatar_cart_container.add_child(avatar_card)
	await(get_tree().process_frame)
	avatar_card.update_avatar(avatar_name, texture_path)


@rpc
func clear_avatar() -> void:
	for child in avatar_cart_container.get_children():
		child.queue_free()

@rpc("any_peer", "call_remote")
func retrieve_avatar(user, session_token) -> void:
	pass


@rpc("any_peer", "call_remote")
func authenticate_player(user, password) -> void:
	pass


@rpc
func authentication_failed(error_message) -> void:
	pass


@rpc
func authentication_successful(user, session_token) -> void:
	pass
