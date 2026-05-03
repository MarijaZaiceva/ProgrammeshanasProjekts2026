extends Node

var panel: Node = null
var textInside: Node = null
var loaded: bool = false
var is_talking: bool = false
var fullscript : String

#var json : JSON
#var res
#var urlbase : String = "https://handheld-emporium-irate.ngrok-free.dev/"
#var url: String
#@onready var http := HTTPRequest.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#http.request_completed.connect(_on_request_completed)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func start_talking_with_(name: String, num: int) -> void:
	#fullscript = get_fullscript(name, num)
	if not loaded:
		load_needed_things_pls()
		loaded = true
	if is_talking:
		return
	is_talking = true
	panel.set_visible(true)
	say(name+str(num))
	
#func get_fullscript(name: String, num: int) -> String:
	#url = urlbase + "players/"+ str(num)
	#http.request(url)
	#await get_tree().create_timer(10.0).timeout
	#if res == "RESULT_SUCCESS":
	#	return str(json)
	#	res = ""
	#else:
	#	return "sorry bruv"
	
	
#func _on_request_completed(result, response_code, headers, body):
#	json = JSON.parse_string(body.get_string_from_utf8())
#	res = result
#	print(json["username"])
	
func load_needed_things_pls() -> void:
	panel = get_tree().get_nodes_in_group("SpeechPanel")[0]
	textInside = get_tree().get_nodes_in_group("SpeechPanel")[1]
	
func say(words: String):
	for letter in words:
		await get_tree().create_timer(0.1).timeout
		textInside.text = textInside.text+letter
	await get_tree().create_timer(3.0).timeout
	textInside.text = ""
	panel.set_visible(false)
	is_talking = false
	
