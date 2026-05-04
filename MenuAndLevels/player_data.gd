extends Panel

var hasher := HashingContext.new()

const ButtonText = ["Log in", "Sign in"]
const ButtonGroups = ["LoginObjects","SigninObjects"]
enum Operations {LOG_IN, SIGN_IN}
var operationRN = Operations.LOG_IN
var valid_data := false

@onready var switch_button:= get_tree().get_nodes_in_group("Buttons")[0]
@onready var input_button:= get_tree().get_nodes_in_group("Buttons")[1]
var httpCheck:Node = null
var httpAdd:Node = null

var json


const url = "https://handheld-emporium-irate.ngrok-free.dev/"

signal server_responded
signal check_completed
signal addition_completed
signal sign_in_done

# For uhm when switch opertaitititi
func _change_operation() -> void:
	match operationRN:
		Operations.LOG_IN:
			operationRN = Operations.SIGN_IN
		Operations.SIGN_IN:
			operationRN = Operations.LOG_IN
	input_button.text=(ButtonText[operationRN])
	switch_button.text=(ButtonText[1-operationRN])
	
	for obj in get_tree().get_nodes_in_group(ButtonGroups[operationRN]):
		obj.set_visible(true)
	for obj in get_tree().get_nodes_in_group(ButtonGroups[1-operationRN]):
		obj.set_visible(false)

func _on_switch_op_button_down() -> void:
	_change_operation()
	 # Replace with function body.
	
# sum additional

#this gon be communication with the server
func valid ():
	valid_data=false
	await get_tree().create_timer(0.3).timeout
	
	if httpCheck==null or httpAdd==null :
		httpCheck = $CheckPlayer
		httpAdd = $AddPlayer
		httpCheck.request_completed.connect(self.after_checking)
		httpAdd.request_completed.connect(self.after_adding)
	match operationRN:
		Operations.LOG_IN:
			var base = get_tree().get_nodes_in_group(ButtonGroups[0])
			var usn = base[0].get_text()
			var pas = base[1].get_text()
			if not recieved_valid_input_([usn,pas]):
				#result
				valid_data = false
				SignalBus.got_news.emit()
				return
			pas=hash_that_(pas)
			print (usn, pas)
			log_in(usn, pas)
			await check_completed
			#result
			SignalBus.got_news.emit()
			return
			
		Operations.SIGN_IN:
			var base = get_tree().get_nodes_in_group(ButtonGroups[1])
			var usn = base[0].get_text()
			var pas = base[1].get_text()
			var pas2 = base[2].get_text()
			#we checked for same password
			if pas != pas2:
				#result
				valid_data=false
				SignalBus.got_news.emit()
				return
			if not recieved_valid_input_([usn,pas,pas2]):
				#result
				valid_data=false
				SignalBus.got_news.emit()
				return
			pas=hash_that_(pas)
			sign_in(usn, pas)
			await sign_in_done
			#result
			SignalBus.got_news.emit()
			return
	#result
	valid_data=false
	SignalBus.got_news.emit()
	return
	
func hash_that_(data:String)->String:
	hasher.start(HashingContext.HASH_SHA256)
	hasher.update(data.to_utf8_buffer())
	return hasher.finish().hex_encode()
	
func recieved_valid_input_(data:Array)-> bool:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9_]*$")
	for d in data:
		if d == "": return false
		if regex.search(d) == null: return false
	return true
	
func sign_in(usn:String, pas:String):
	await get_tree().create_timer(0.1).timeout
	check_player_existance(usn)
	print("checked player existance, ")
	await server_responded
	if valid_data: 
		add_user(usn, pas)
		await addition_completed
		sign_in_done.emit
		print("returned valid " + str(valid_data))
		return
	print("returned invalid " + str(valid_data))
	sign_in_done.emit
	
func log_in(usn:String, pas:String):
	await get_tree().create_timer(0.1).timeout
	check_player_existance(usn)
	await server_responded
	if valid_data: valid_data = check_password(pas, json)
	check_completed.emit()
	
func check_player_existance(usn:String):
	await get_tree().create_timer(0.1).timeout
	var newurl = url + "players/" + usn
	print(newurl)
	var headers = ["Content-Type: application/json"]
	httpCheck.request(newurl, headers, HTTPClient.METHOD_GET)
	
func after_checking(results, response_code, headers, body):	
	var json_string = body.get_string_from_utf8()
	json = JSON.parse_string(json_string)
	print (json)
	match operationRN:
		Operations.LOG_IN:
			if json.has("username"):valid_data = true
		Operations.SIGN_IN:
			if json.has("detail"):valid_data = true
	server_responded.emit()
	
func after_adding(results, response_code, headers, body):
	var json_string = body.get_string_from_utf8()
	json = JSON.parse_string(json_string)
	print (json)
	if json.has("detail") and json.detail =="Player with that username already exists":
		valid_data = false
	addition_completed.emit()

func check_password(pas, j)->bool:
	return j["password_hash"]==pas
	
func add_user(usn, pas):
	await get_tree().create_timer(0.1).timeout
	var newurl = url + "players/"
	print(newurl)
	var headers = ["Content-Type: application/json"]
	var body := { "username": usn, "password_hash": pas}
	httpAdd.request(newurl, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	


func error () -> String:
	match operationRN:
		Operations.LOG_IN:
			return "● can't log in. Check for spelling mistakes."
		Operations.SIGN_IN:
			return "● can't let you join. Aura too low."
	return "tfff"
