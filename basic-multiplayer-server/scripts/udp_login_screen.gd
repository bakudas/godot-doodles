extends Control

const PORT: int = 4242
const HOST: String = "127.0.0.1"
@onready var user_editlist = $VBoxContainer/UserLineEdit
@onready var pass_editlist = $VBoxContainer/PassLineEdit

func send_credentials():
	var message = {
		'authenticate_credentials': {
			'username': user_editlist.text, 
			'password': pass_editlist.text
		}
	}
	var packet = PacketPeerUDP.new()
	packet.connect_to_host(HOST, PORT)
	packet.put_var(JSON.stringify(message))
	while packet.wait() == OK:
		var data = JSON.parse_string(packet.get_var())
		if "token" in data:
			$VBoxContainer/ErroMessage.text = "logged!!"
			AuthenticationCredentials.username = message['authenticate_credentials']['username']
			AuthenticationCredentials.access_token = data['token']
			print("send credentials for {username} with token {access_token}"
			.format({
				'username': AuthenticationCredentials.username, 
				'access_token': AuthenticationCredentials.access_token}
			))
			get_tree().change_scene_to_file("res://scenes/avatar_screen.tscn")
			break
		else:
			$VBoxContainer/ErroMessage.text = "login failed, check your credentials"
			break


func _on_login_button_pressed() -> void:
	send_credentials()
