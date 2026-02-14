@abstract
class_name RPCMultiplayer extends Node

@abstract
@rpc
func add_avatar(avatar_name, texture_path) -> void

@abstract
func clear_avatar() -> void

@abstract
func retrieve_avatar(user, session_token) -> void

@abstract
func authenticate_player(user, password) -> void

@abstract
func authentication_failed(error_message: String) -> void

@abstract
func authentication_successful(user, session_token) -> void
