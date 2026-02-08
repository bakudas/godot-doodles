extends Node2D


const PORT: int = 4242
const HOST: String = "localhost"
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()


func _ready() -> void:
	var error: Error = peer.create_client(HOST, PORT)
	multiplayer.multiplayer_peer = peer
	
