extends Control

const HOST: String = "127.0.0.1"
const PORT: int = 4242


func _ready() -> void:
	print("%s logged in!" % AuthenticationCredentials.username)
	var packet = PacketPeerUDP.new()
	packet.connect_to_host(HOST, PORT)
	request_authentication(packet)


func request_authentication(packet):
	var request = {
		"get_authentication_token": true,
		"username": AuthenticationCredentials.username,
		"token": AuthenticationCredentials.access_token
	}
	packet.put_var(JSON.stringify(request))
	while packet.wait() == OK:
		var data = JSON.parse_string(packet.get_var())
		if data == AuthenticationCredentials.access_token:
			request_avatar(packet)
			break


func request_avatar(packet):
	var request = {
		"get_avatar": true, 
		"username": AuthenticationCredentials.username,
		"token": AuthenticationCredentials.access_token
	}
	packet.put_var(JSON.stringify(request))
	while packet.wait() == OK:
		var data = JSON.parse_string(packet.get_var())
		download_avatar(data['avatar_id'][0], data['token'])
		#$VBoxContainer/TextureRect.texture = texture
		$VBoxContainer/Label.text = AuthenticationCredentials.username
		break


func download_avatar(asset_id: String, token: String):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Importante: Para baixar imagens, não precisamos de headers complexos, 
	# apenas o Bearer se o asset não for público.
	var headers = ["Authorization: Bearer " + token]
	
	# Conecta ao sinal específico para processar a imagem
	http_request.request_completed.connect(_on_image_downloaded)
	
	# Endpoint de Assets do Squidex
	var url = "https://bke.pixelcartel.com.br/api/assets/game-backend/" + asset_id
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_GET)
	if error != OK:
		push_error("Erro ao iniciar download da imagem.")

func _on_image_downloaded(result, response_code, headers, body):
	if response_code == 200:
		var image = Image.new()
		var error = image.load_jpg_from_buffer(body) # Tenta JPG
		
		if error != OK:
			error = image.load_png_from_buffer(body) # Tenta PNG se JPG falhar
			
		if error == OK:
			var texture = ImageTexture.create_from_image(image)
			$VBoxContainer/TextureRect.texture = texture
			print("Avatar aplicado com sucesso!")
		else:
			push_error("Falha ao converter dados do corpo em imagem.")
	else:
		print("Erro no download: ", response_code)
