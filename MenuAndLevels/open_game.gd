extends Node2D
const menu_path = Constants.GET_SCENE.menu
var player_data : Panel = null
var error_area : Label = null
var loader : CharacterBody2D = null

var button_at_work:=false

func _ready() -> void:
	player_data = self.find_child("PlayerData")
	error_area = self.find_child("Error")
	loader = self.find_child("Loader")
	

func _on_process_input_button_down() -> void:
	if button_at_work: 
		print("gay")
		return
	button_at_work=true
	loader.visible = true
	player_data.valid()
	await SignalBus.got_news
	loader.visible = false
	
	if player_data.valid_data:
		player_data.playerID=player_data.json["id"]
		print(player_data.playerID)
		SceneLoader.load_scene(menu_path)
	else:
		error_area.visible=true
		error_area.text = player_data.error()
		#set
	button_at_work = false
	pass # Replace with function body.
	
