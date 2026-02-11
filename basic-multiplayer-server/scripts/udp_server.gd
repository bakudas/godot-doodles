extends Node2D

const PORT: int = 4242
var server: UDPServer = UDPServer.new()
@export var database_file_path = "res://fake_database.json"
var fake_database = {}
var user_data
var logged_users = {}
var backend_token
@export var teste: PackedByteArray

func _ready() -> void:
	server.listen(PORT)
	print("server online: " + str(server.is_listening()))
	load_database(database_file_path)


func _process(delta: float) -> void:
	server.poll()
	if server.is_connection_available():
		var peer = server.take_connection()
		var message = JSON.parse_string(peer.get_var())
		if "authenticate_credentials" in message:
			authenticate_player(peer, message)
		elif "get_authentication_token" in message:
			get_authentication_token(peer, message)
		elif "get_avatar" in message:
			get_avatar(peer, message)


func authenticate_player(peer, message):
	var credentials = message['authenticate_credentials']
	if "username" in credentials and "password" in credentials:
		var username = credentials["username"]
		var password = credentials["password"]
		if user_data['data']['username']['en'] == username:
			if user_data['data']['password']['iv'] == password:
				var token = randi()
				var response = {'token': token, 'username': username}
				logged_users[username] = token
				print("authenticated player: %s" % str(response))
				peer.put_var(JSON.stringify(response))
			else:
				peer.put_var("")


func load_database(data_path) -> Dictionary:
	#var file = FileAccess.open(data_path, FileAccess.READ)
	#var file_content = file.get_as_text()
	#fake_database = JSON.parse_string(file_content)
	#print("fake data: %s" % str(fake_database))
	send_auth_request()
	return fake_database


func get_authentication_token(peer, message):
	var credentials = message
	if "username" in credentials:
		if credentials['token'] == logged_users[credentials['username']]:
			var token = logged_users[credentials['username']]
			var response = {'token': token, 'username': credentials['username']}
			print("get auth token: %s" % str(response))
			peer.put_var(JSON.stringify(token))


func get_avatar(peer, message):
	var data = {
		'avatar_id': user_data['data']['avatarImage']['iv'],
		'token': backend_token
	}
	peer.put_var(JSON.stringify(data))


func send_auth_request():
	var http_request = HTTPRequest.new()
	add_child(http_request)

	# Conecta o sinal para processar a resposta
	http_request.request_completed.connect(_on_request_completed)

	# Configuração dos Headers
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	# Configuração do Body (Dados do formulário)
	var data = {
		"grant_type": "client_credentials",
		"client_id": "game-backend:default",
		"client_secret": "bmv0svctp71dxvciob55isznhdmxasx3xzn7ppqb6qkx",
		"scope": "squidex-api"
	}

	# Transforma o dicionário em string formatada: key1=value1&key2=value2
	var query_string = HTTPClient.new().query_string_from_dict(data)

	var url = "https://bke.pixelcartel.com.br/identity-server/connect/token"

	# Realiza a requisição POST
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, query_string)

	if error != OK:
		push_error("Ocorreu um erro ao iniciar a requisição HTTP.")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())

	if response_code == 200:
		var response_data = json.get_data()
		backend_token = response_data["access_token"]
		get_user_data(backend_token, "1e2c5075-ecdf-41aa-b15d-c9f17d1d642d")
		print("Token recebido: ", response_data["access_token"])
	else:
		print("Erro na autenticação. Código: ", response_code)
		print("Resposta: ", body.get_string_from_utf8())

func get_user_data(token: String, user_id: String):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Conexão do sinal para tratar o retorno dos dados do usuário
	http_request.request_completed.connect(_on_user_data_received)

	# Headers: Incluindo o Bearer Token
	var headers = [
		"Authorization: Bearer " + token,
		"Content-Type: application/json"
	]
	
	var url = "https://bke.pixelcartel.com.br/api/content/game-backend/user/" + user_id + "/"
	
	# Requisição GET (padrão para leitura de dados)
	var error = http_request.request(url, headers, HTTPClient.METHOD_GET)
	
	if error != OK:
		push_error("Erro ao solicitar dados do usuário.")


func _on_user_data_received(result, response_code, headers, body):
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	
	if response_code == 200:
		user_data = json.get_data()
		print("Dados do usuário carregados: ", user_data['data'])
	elif response_code == 401:
		print("Erro: Token expirado ou inválido.")
	else:
		print("Erro ao buscar usuário. Código: ", response_code)
