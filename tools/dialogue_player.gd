extends Node

var panel: Node = null
var textInside: Node = null
var loaded: bool = false
var is_talking: bool = false
var user_offline := false 

var url = PlayerData.url

signal got_script
signal got_dd
signal line_data_recieved
signal said_the_line
signal got_options

var httpDial : HTTPRequest
var httpLine : HTTPRequest
var httpChoice : HTTPRequest

var firstline:int
var line:int
var nextline:int
var collecting_data:bool=true

var full_script:Array
var options:Array
#var json : JSON
#var res
#var urlbase : String = "https://handheld-emporium-irate.ngrok-free.dev/"
#var url: String
#@onready var http := HTTPRequest.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	httpDial = HTTPRequest.new()
	httpLine = HTTPRequest.new()
	httpChoice = HTTPRequest.new()
	add_child(httpDial)
	add_child(httpLine)
	add_child(httpChoice)
	httpDial.request_completed.connect(self.httpDial_request_completed)
	httpLine.request_completed.connect(self.httpLine_request_completed)
	httpChoice.request_completed.connect(self.httpChoice_request_completed)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func start_talking_(num: int) -> void:
	#fullscript = get_fullscript(name, num)
	if not loaded:
		load_needed_things_pls()
		loaded = true
	if is_talking:
		return
	panel.set_visible(true)
	is_talking = true
	get_dialogue_script(num)
	await got_script
	if user_offline:
		return
	print (full_script)
	for l in full_script:
		say(l["lineENG"])
		await said_the_line
		if l["choiceID"]!= null:
			SignalBus.emit_signal("create_choice", options)
			await SignalBus.made_choice
	Progress.mark_as_heard(num)
	panel.set_visible(false)
	is_talking = false	
	
	
func get_dialogue_script(num:int) -> void:
	get_dialogue_data(num)
	await got_dd
	if user_offline: push_error ( "offline" )
	print("still standing")
	collecting_data = true
	line = firstline
	full_script = []
	while collecting_data:
		get_full_script(num, line)
		print(line)
		await line_data_recieved
		if user_offline: push_error ( "offline" )
	if user_offline: push_error ( "offline" )
	got_script.emit()
	
	
	
func get_dialogue_data(num:int) -> void:
	await get_tree().create_timer(0.01).timeout
	var newurl = url + "dialogues/" + str(num)
	print(newurl)
	var headers = ["Content-Type: application/json"]
	httpDial.request(newurl, headers, HTTPClient.METHOD_GET)
	
func httpDial_request_completed(results, response_code, headers, body):
	if results > 0: #offline
		user_offline = true
		got_dd.emit()
		return
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse_string(json_string) #extracting json
	print (json)
	if json.has('details'): push_error('dialogue doesn\'t exist')
	#if json["checkAcces"]: print("check acess"+str(json["altDial"])) #replace later
	firstline = json["firstLine"]
	print(firstline)
	got_dd.emit()
	
	
func get_full_script(num, l):
	await get_tree().create_timer(0.01).timeout
	var newurl = url + "dlgLines/" + str(num)+"/"+str(l)
	print(newurl)
	var headers = ["Content-Type: application/json"]
	httpLine.request(newurl, headers, HTTPClient.METHOD_GET)
	
func httpLine_request_completed(results, response_code, headers, body):
	if results > 0: #offline
		user_offline = true
		collecting_data = false
		line_data_recieved.emit()
		return
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse_string(json_string) #extracting json
	print (json)
	if json.has('detail'): push_error('line doesn\'t exist')
	line = json["nextLine"]
	
	if json["choiceID"]!=null:
		get_options(json["choiceID"])
		await got_options
		print("recieved signal")
		if user_offline: push_error('offline!')
	
	if line == firstline : collecting_data = false
	full_script.append(json)
	line_data_recieved.emit()
	
	
func load_needed_things_pls() -> void:
	panel = get_tree().get_nodes_in_group("SpeechPanel")[0]
	textInside = get_tree().get_nodes_in_group("SpeechPanel")[1]
	
func say(words: String):
	for letter in words:
		await get_tree().create_timer(0.05).timeout
		textInside.text = textInside.text+letter
	await get_tree().create_timer(1.5).timeout
	textInside.text = ""
	said_the_line.emit()
	
func get_options(id)->void:
	await get_tree().create_timer(0.01).timeout
	var newurl = url + "choices/" + id
	print(newurl)
	var headers = ["Content-Type: application/json"]
	httpDial.request(newurl, headers, HTTPClient.METHOD_GET)
	
func httpChoice_request_completed(results, response_code, headers, body):
	if results > 0: #offline
		user_offline = true
		collecting_data = false
		push_error('error')
		return
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse_string(json_string) #extracting json
	print (json)
	if json.has('detail'): push_error('choice doesn\'t exist')
	if not (json.has("cru") and json.has("opt1") and json.has("opt2") and json.has("opt3")):
		push_error("Missing expected fields")
		return

	options = [json["cru"], json["opt1"], json["opt2"], json["opt3"]]
	print(options)

	got_options.emit()


func dialogue_aftermath(num):
	pass
	
