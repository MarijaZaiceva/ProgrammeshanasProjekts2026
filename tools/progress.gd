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
signal saved_progress

var httpGetProg : HTTPRequest
var httpSaveProg : HTTPRequest
var player : Node

var managing:=true
var user_offline := false
var qurently_saving := false
var already_settled:=false

func _ready() -> void:
	httpGetProg = HTTPRequest.new()
	httpSaveProg = HTTPRequest.new()
	add_child(httpGetProg)
	add_child(httpSaveProg)
	httpGetProg.request_completed.connect(self.httpGetProg_request_completed)
	httpSaveProg.request_completed.connect(self.httpSaveProg_request_completed)

func managing_progress()->void:
	print("got player id: "+str(playerID))
	get_progress()
	await got_progress
	if user_offline: push_error("offline!")
	SignalBus.settled_data.emit()
	already_settled=true
	while managing:
		await get_tree().create_timer(120.0).timeout
		save_progress()
		if user_offline: push_error("offline!")
	

func get_progress ():
	await get_tree().create_timer(0.01).timeout
	var newurl = url + "saving/" + str(playerID)
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
		save_progress()
		await saved_progress
		got_progress.emit()
	else:
		var player = get_tree().get_nodes_in_group("Player")[0]
		for key in PROGRESS:
			PROGRESS[key]=json[key]
		player.global_position = Vector3(json["position_x"],json["position_y"],json["position_z"])
		got_progress.emit()


	
func save_progress ():
	var p = PROGRESS
	if qurently_saving:return
	qurently_saving = true
	print("saving")
	var player = get_tree().get_nodes_in_group("Player")[0]
	if player == null: push_error("the system is fucked upp bro")
	p["position_x"]=player.global_position.x
	p["position_y"]=player.global_position.y
	p["position_z"]=player.global_position.z
	
	await get_tree().create_timer(0.01).timeout
	var newurl = url + "saving/" + str(playerID) 
	print(newurl)
	var headers = ["Content-Type: application/json"]
	var body = p
	httpSaveProg.request(newurl, headers, HTTPClient.METHOD_PUT, JSON.stringify(body))
	
	
func httpSaveProg_request_completed(results, response_code, headers, body):
	if results > 0:
		user_offline=true
	saved_progress.emit()
	qurently_saving = false
	return
	
func check_as_heard(num:int):
	if heard_already(num, PROGRESS["dialogues"]): return
	PROGRESS["dialogues"] += 10**(num-1)
	print(PROGRESS["dialogues"])
		
func heard_already(d:int, index:int):
	var controler1:int=10**(d-1)
	var controler2:int=10**(d)
	print(controler1)
	print(controler2) 
	var controler: int = index%controler2 - index%controler1
	return controler > 0 
	
