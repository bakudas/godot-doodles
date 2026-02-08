extends Node2D

const PORT: int = 4242
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _ready() -> void:
	var error: Error = peer.create_server(PORT)
	if error:
		print(error)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)


func _on_peer_connected(peer_id) -> void:
	print(peer_id)
