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

const url = "https://handheld-emporium-irate.ngrok-free.dev/"

signal server_responded

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
	if httpCheck==null or httpAdd==null :
		httpCheck = $CheckPlayer
		httpAdd = $AddPlayer
		httpCheck.request_completed.connect(self._after_checking)
		httpAdd.request_completed.connect(self._after_adding)
	match operationRN:
		Operations.LOG_IN:
			var base = get_tree().get_nodes_in_group(ButtonGroups[0])
			var usn = base[0].get_text()
			var pas = base[1].get_text()
			if not recieved_valid_input_([usn,pas]):
				#result
				valid_data=false
				SignalBus.got_news.emit()
				return
			pas=hash_that_(pas)
			print (usn, pas)
			log_in(usn, pas)
			await server_responded
			#result
			valid_data = true
			SignalBus.got_news.emit()
			return
			
		Operations.SIGN_IN:
			var base = get_tree().get_nodes_in_group(ButtonGroups[1])
			print(base)
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
			print (usn, pas, pas2)
			send_n_check_(usn, pas)
			await server_responded
			#result
			valid_data=true
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
	
func send_n_check_(usn:String, pas:String):
	check_player_existance(usn, pas)
	await server_responded
	
func log_in(usn:String, pas:String):
	check_player_existance(usn, pas)
	
func check_player_existance(usn:String, pas:String):
	var newurl = url + "players/" + usn
	print(newurl)
	var headers = ["Content-Type: application/json"]
	httpCheck.request(newurl, headers, HTTPClient.METHOD_GET)
	
func _after_checking(results:String, response_code, headers, body):
	var json =JSON.parse_string(body.get_string_from_utf8)
	print (json)
	server_responded.emit()
	
func _after_adding(results:String, response_code, headers, body):
	pass


func error () -> String:
	match operationRN:
		Operations.LOG_IN:
			return "● can't log in. Check for spelling mistakes."
		Operations.SIGN_IN:
			return "● can't let you join. Aura too low."
	return "tfff"
