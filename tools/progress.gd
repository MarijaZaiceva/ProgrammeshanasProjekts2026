extends Node
 
@export var PROGRESS: Dictionary = {
  "position_x": 0,
  "position_y": 0,
  "position_z": 0,
  "money": 0,
  "weapon": "fists",
  "dialogues": 0,
  "clothes": 0
}
var url = PlayerData.url
var playerID
signal got_progress
var managing:bool=true
var httpGetProg : HTTPRequest
var httpSaveProg : HTTPRequest
var player : Node
var user_offline := false

func _ready() -> void:
	add_child(httpGetProg)
	add_child(httpSaveProg)
	httpGetProg.request_completed.connect(self.httpGetProg_request_completed)
	httpSaveProg.request_completed.connect(self.httpSaveProg_request_completed)

func managing_progress()->void:
	playerID=PlayerData.PlayerID
	get_progress()
	await got_progress
	if user_offline: push_error("offline!")
	while managing:
		await get_tree().create_timer(120.0).timeout
		save_progress(PROGRESS)
		if user_offline: push_error("offline!")
	

func get_progress ():
	await get_tree().create_timer(0.01).timeout
	var newurl = url + "saving/" + playerID
	print(newurl)
	var headers = ["Content-Type: application/json"]
	httpGetProg.request(newurl, headers, HTTPClient.METHOD_GET)
	
func httpGetProg_request_completed(results, response_code, headers, body):
	if results > 0:
		user_offline = true
		got_progress.emit()
		return
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse_string(json_string)
	print (json)
	if json["position_x"] == null: 
		return
	else:
		for key in PROGRESS:
			PROGRESS[key]=json[key]
		got_progress.emit()


	
func save_progress (p):
	player = get_tree().get_nodes_in_group("Player")[0]
	if player == null: push_error("the system is fucked upp bro")
	p["position_x"]=player.global_position.x
	p["position_y"]=player.global_position.y
	p["position_z"]=player.global_position.z
	
	var body = "lol"
	httpSaveProg.request
	
func httpSaveProg_request_completed(results, response_code, headers, body):
	return
